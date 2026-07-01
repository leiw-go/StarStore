#!/usr/bin/env python3
"""Parse Big Bang Theory SRT files and generate per-episode Markdown."""
import os
import re
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
SOURCE_DIR = BASE_DIR / "source"
OUTPUT_DIR = BASE_DIR / "episodes"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def clean_text(text: str) -> str:
    """Strip SSA/ASS formatting tags and extra whitespace."""
    # Remove {\...} style tags
    text = re.sub(r"\{[^}]*\}", "", text)
    # Remove <font ...> tags
    text = re.sub(r"<[^>]+>", "", text)
    # Remove {\r} line breaks
    text = text.replace("\\r", "").replace("\\N", " ")
    return text.strip()


def is_promotional(text: str) -> bool:
    """Detect watermark/ad entries (e.g. ABContainer, 微信公众号)."""
    keywords = ["ABContainer", "微信公众号", "东西容器", "必属精品", "获取更多剧集"]
    return any(k in text for k in keywords)


def parse_srt(content: str) -> list[dict]:
    """Parse a bilingual SRT file into a list of subtitle dicts.

    Each entry has: index, start, end, zh, en.
    Promotional/watermark entries are skipped.
    """
    # Strip UTF-8 BOM
    content = content.lstrip("﻿")
    # Normalise newlines
    content = content.replace("\r\n", "\n").replace("\r", "\n")
    blocks = re.split(r"\n{2,}", content.strip())

    entries = []
    for block in blocks:
        lines = [ln for ln in block.split("\n") if ln.strip()]
        if len(lines) < 3:
            continue
        # First line: index
        if not lines[0].strip().isdigit():
            continue
        # Second line: timestamp
        ts_match = re.match(
            r"(\d{2}:\d{2}:\d{2}[,\.]\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2}[,\.]\d{3})",
            lines[1],
        )
        if not ts_match:
            continue
        start, end = ts_match.group(1), ts_match.group(2)

        text_lines = lines[2:]
        cleaned = [clean_text(ln) for ln in text_lines]
        cleaned = [c for c in cleaned if c]

        if not cleaned:
            continue
        if any(is_promotional(c) for c in cleaned):
            continue

        # Convention: first non-empty cleaned line is Chinese, second is English.
        # Some entries have only one line (usually an English-only line).
        if len(cleaned) == 1:
            line = cleaned[0]
            # Heuristic: if it contains CJK characters, treat as zh; else en.
            if re.search(r"[一-鿿]", line):
                zh, en = line, ""
            else:
                zh, en = "", line
        else:
            zh, en = cleaned[0], cleaned[1]

        # Reject if both are empty
        if not zh and not en:
            continue

        entries.append(
            {"index": int(lines[0]), "start": start, "end": end, "zh": zh, "en": en}
        )

    return entries


# Whitelist of opener roots that strongly indicate a common conversational phrase.
# Format: regex that matches at the *start* of the cleaned English line.
COMMON_PHRASE_PATTERNS = [
    # Greetings / farewells
    r"^(hi|hey|hello|hiya|howdy|yo)\b",
    r"^(bye|goodbye|good night|good morning|see you|see ya|goodbye[, ]|later|nighty[- ]night)\b",
    # Polite / courtesy
    r"^(please|thank you|thanks|sorry|excuse me|you'?re welcome|no problem|my pleasure|not at all|pardon)\b",
    # Agreement / disagreement / acknowledgement
    r"^(agreed|sure|exactly|absolutely|definitely|certainly|of course|obviously|apparently|evidently|indeed|exactly|right|correct|okay|ok|fine|great|cool|nice|sweet)\b",
    r"^(no|nope|nah|yes|yeah|yep|yup|sure thing)\b",
    r"^(i (?:don'?t know|i see|i agree|i disagree|i guess|i suppose|i think|i believe|i assume|i remember|i forget|i bet|i hope|i wish|i promise|i swear|i admit|i confess|i apologize)\.?)",
    r"^(well[, ]|so[, ]|oh[, ]|ah[, ])",
    # Question openers
    r"^(what(?:'s| is| are| do| did| does| would| will| should| about| happened| wrong| the (?:matter|hell))\b)",
    r"^(where(?:'s| is| are| did| do| does| will| would| should| about| to)\b)",
    r"^(when(?:'s| is| are| did| do| does| will| would| should| about)\b)",
    r"^(who(?:'s| is| are| did| do| does| will| would| should| about)\b)",
    r"^(why(?:'s| is| are| did| do| does| will| would| should| not| don'?t| didn'?t| doesn'?t| wouldn'?t| can'?t)\b)",
    r"^(how(?:'s| is| are| did| do| does| will| would| should| about| come| many| much| long| often| old| far| could| can)\b)",
    r"^(are you (?:serious|kidding|okay|all right|coming|done|sure|free|ready|listening|crazy|insane|nuts|out of your mind)\b)",
    r"^(can i (?:help|ask|have|get|see|talk|say|borrow|use|come|try|do)\b)",
    r"^(could i (?:help|ask|have|get|see|talk|say|borrow|use|come|try|do)\b)",
    r"^(do you (?:mind|want|have|know|think|see|understand|remember|like|need|hear|have any)\b)",
    r"^(did you (?:know|see|hear|find|get|talk|tell)\b)",
    r"^(would you (?:like|care|mind|please|want|help|pass|come|do|be|try|give|tell|let)\b)",
    r"^(will you (?:please|help|be|do|come|try|tell|let)\b)",
    # Common imperatives / fillers
    r"^(wait|hold on|hang on|come on|let'?s|go ahead|take care|take it easy|enjoy|cheers|good[- ]bye|good luck|have fun|no way|of course|by all means|you bet|sure thing|go for it|don'?t (?:worry|mind|forget|sweat|be silly|be ridiculous|be (?:absurd|ridiculous))\b)",
    r"^(what do you (?:think|mean|say|want|suppose|suggest)\b)",
    r"^(i (?:have|had|don'?t have|got|don'?t got|need|want|would|will|can|could|should|would like)\b)",
    r"^(i'?m (?:sorry|afraid|going|gonna|coming|here|back|ready|sure|not|with you|in)\b)",
    r"^(let'?s (?:go|see|do|try|have|make|get|talk|find|figure|just|start|head|call|ask|eat|play|head)\b)",
    r"^(it'?s (?:okay|ok|alright|all right|fine|cool|nice|fun|great|good|nothing|important|possible|impossible|hard|difficult|tough)\b)",
    r"^(that'?s (?:it|all|great|good|nice|cool|fun|weird|strange|interesting|ridiculous|absurd|terrible|awful|amazing|incredible|fantastic|unbelievable)\b)",
    r"^(there'?s (?:no|not|a|an|one|two|three)\b)",
    r"^(my (?:pleasure|point|bad|god|gosh|goodness|head)\b)",
    r"^(good (?:point|idea|luck|catch|question)\b)",
    r"^(no (?:problem|way|thanks|worry|doubt|offense|idea|need|question|kidding)\b)",
    r"^(you (?:know|see|got me|got it|have a point|are right|are wrong|are welcome|think so|know what)\b)",
    r"^(of course[, ]|by all means[, ]|in (?:fact|other words|any case|the meantime|general|theory|principle)\b)",
    r"^(kind of|sort of)\b",
    # Reactions
    r"^(really\??|seriously\??|are you (?:serious|kidding)\??|no way!?|you' )",
]

COMPILED_PATTERNS = [re.compile(p, re.IGNORECASE) for p in COMMON_PHRASE_PATTERNS]


def is_common_phrase(en_text: str) -> bool:
    """Decide whether an English line counts as a common / useful phrase.

    Rules:
      * Single-speaker line (no embedded " -" cue).
      * <= 6 words.
      * Starts with a recognised conversational opener.
      * Reasonable punctuation (not a trailing comma fragment like
        "But before it hits its target,").
    """
    text = en_text.strip()
    if not text:
        return False
    # Strip leading dash (multi-speaker cues like "-hi. -bye.")
    text = re.sub(r"^-+", "", text).strip()
    if not text:
        return False
    if " -" in text or "— " in text:
        return False
    # Reject if no terminating punctuation and no "?" — likely a fragment.
    last_char = text[-1]
    if last_char not in ".!?":
        return False
    word_count = len(text.split())
    if word_count == 0 or word_count > 6:
        return False
    # Reject explanatory parenthetical asides (often translations).
    if "(" in text or ")" in text:
        return False
    for pat in COMPILED_PATTERNS:
        if pat.match(text):
            return True
    return False


def render_episode(ep_num: int, entries: list[dict]) -> str:
    """Render one episode's markdown."""
    md = []
    md.append(f"# 生活大爆炸 S01E{ep_num:02d} 台词与常用短语\n")
    md.append("> 整理自 `SHDBZ S01E{0:02d}.srt` 中英双语字幕\n".format(ep_num))
    md.append("")
    md.append("---")
    md.append("")

    # Dialogue section
    md.append("## 一、中英台词对照")
    md.append("")
    for entry in entries:
        ts = f"`{entry['start']} --> {entry['end']}`"
        md.append(f"### {entry['index']}. {ts}")
        if entry["zh"]:
            md.append(f"- **中文**：{entry['zh']}")
        if entry["en"]:
            md.append(f"- **英文**：{entry['en']}")
        md.append("")

    # Common phrases section
    md.append("---")
    md.append("")
    md.append("## 二、常用短语")
    md.append("")
    md.append("| # | 英文 | 中文 | 出处 |")
    md.append("|---|------|------|------|")
    seen = set()
    n = 1
    for entry in entries:
        en = entry["en"].strip()
        if not en:
            continue
        # Skip multi-speaker lines
        if re.search(r"\s-\s|^-\s| -", en):
            continue
        if not is_common_phrase(en):
            continue
        key = en.lower().rstrip(".!?")
        if key in seen:
            continue
        seen.add(key)
        md.append(
            f"| {n} | {en} | {entry['zh']} | 第 {entry['index']} 条 |"
        )
        n += 1
    md.append("")
    return "\n".join(md)


def main():
    files = sorted(SOURCE_DIR.glob("SHDBZ S01E*.srt"))
    # Only process the bilingual (non-EN) files
    bilingual = [f for f in files if not f.stem.endswith("-EN")]
    print(f"Found {len(bilingual)} bilingual SRT files.")

    for srt in bilingual:
        # Extract episode number, e.g. "SHDBZ S01E03.srt" -> 3
        m = re.search(r"S01E(\d+)", srt.name)
        if not m:
            continue
        ep_num = int(m.group(1))
        content = srt.read_text(encoding="utf-8")
        entries = parse_srt(content)
        print(f"  E{ep_num:02d}: parsed {len(entries)} entries")
        md = render_episode(ep_num, entries)
        out_path = OUTPUT_DIR / f"S01E{ep_num:02d}.md"
        out_path.write_text(md, encoding="utf-8")
        print(f"     -> wrote {out_path} ({len(md)} chars)")
    print("Done.")


if __name__ == "__main__":
    main()
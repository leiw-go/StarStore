#!/usr/bin/env node

import { promises as fs } from "node:fs";
import path from "node:path";

const args = process.argv.slice(2);
const strict = args.includes("--strict");
const targetArg = args.find((arg) => !arg.startsWith("--")) ?? ".";
const root = path.resolve(targetArg);
const allowed = new Set([".css", ".scss", ".sass", ".less", ".html", ".jsx", ".tsx", ".vue", ".svelte"]);
const ignored = new Set([".git", "node_modules", "dist", "build", "coverage", ".next", ".nuxt"]);

async function collectFiles(directory) {
  const entries = await fs.readdir(directory, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    if (ignored.has(entry.name)) continue;
    const fullPath = path.join(directory, entry.name);
    if (entry.isDirectory()) files.push(...(await collectFiles(fullPath)));
    if (entry.isFile() && allowed.has(path.extname(entry.name))) files.push(fullPath);
  }

  return files;
}

function has(source, pattern) {
  return pattern.test(source);
}

function count(source, pattern) {
  return [...source.matchAll(pattern)].length;
}

let files;
try {
  files = await collectFiles(root);
} catch (error) {
  console.error(`FU—Liquiglass audit could not read ${root}: ${error.message}`);
  process.exit(2);
}

if (files.length === 0) {
  console.error(`FU—Liquiglass audit found no frontend files in ${root}.`);
  process.exit(2);
}

const sources = await Promise.all(files.map((file) => fs.readFile(file, "utf8")));
const source = sources.join("\n");
const checks = [
  {
    name: "backdrop blur",
    required: true,
    pass: has(source, /(?:-webkit-)?backdrop-filter\s*:/i),
    fix: "Add backdrop-filter and -webkit-backdrop-filter to the shared glass surface.",
  },
  {
    name: "opaque fallback",
    required: true,
    pass: has(source, /@supports[\s\S]{0,900}backdrop-filter/i),
    fix: "Define a readable opaque background, then enhance it inside @supports.",
  },
  {
    name: "reduced motion",
    required: true,
    pass: has(source, /prefers-reduced-motion/i),
    fix: "Add a prefers-reduced-motion rule that removes decorative travel and continuous motion.",
  },
  {
    name: "keyboard focus",
    required: true,
    pass: has(source, /:focus-visible/i),
    fix: "Add visible :focus-visible styling for interactive controls.",
  },
  {
    name: "responsive layout",
    required: true,
    pass: has(source, /@media\s*\([^)]*(?:max-width|min-width)/i),
    fix: "Add a responsive breakpoint and replace hover-only navigation on touch layouts.",
  },
  {
    name: "glass tokens",
    required: false,
    pass: count(source, /--(?:lg|glass)-[\w-]+\s*:/gi) >= 4,
    fix: "Centralize tint, border, blur, radius, highlight, and shadow as CSS custom properties.",
  },
  {
    name: "specular highlight",
    required: false,
    pass:
      has(source, /::(?:before|after)[\s\S]{0,700}(?:linear-gradient|radial-gradient)/i) ||
      has(source, /(?:specular|highlight)/i),
    fix: "Add a restrained directional highlight with a pseudo-element or dedicated layer.",
  },
  {
    name: "forced-colors fallback",
    required: false,
    pass: has(source, /forced-colors\s*:\s*active/i),
    fix: "Add a forced-colors fallback with an opaque surface and visible border.",
  },
];

const blurValues = [...source.matchAll(/blur\(\s*(\d+(?:\.\d+)?)px\s*\)/gi)].map((match) =>
  Number(match[1]),
);
const oversizedBlur = blurValues.filter((value) => value > 40);

console.log(`FU—Liquiglass audit: ${path.relative(process.cwd(), root) || "."}`);
console.log(`Scanned ${files.length} frontend file${files.length === 1 ? "" : "s"}.\n`);

for (const check of checks) {
  const marker = check.pass ? "PASS" : check.required ? "MISS" : "NOTE";
  console.log(`[${marker}] ${check.name}`);
  if (!check.pass) console.log(`       ${check.fix}`);
}

if (oversizedBlur.length > 0) {
  console.log(`\n[NOTE] Found blur values above 40px: ${[...new Set(oversizedBlur)].join(", ")}px.`);
  console.log("       Verify that large blurred areas do not repaint during animation or scroll.");
}

const missingRequired = checks.filter((check) => check.required && !check.pass);
const score = checks.filter((check) => check.pass).length;
console.log(`\nResult: ${score}/${checks.length} safeguards detected.`);

if (strict && missingRequired.length > 0) {
  console.error(`Strict mode failed: ${missingRequired.length} required safeguard(s) missing.`);
  process.exit(1);
}


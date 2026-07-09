# AkShare — 一行 Python 拉全网财经数据

> 🐂 A股 / 期货 / 基金 / 外汇 / 债券 / 指数 / 加密货币……一个库搞定
>
> GitHub：<https://github.com/akfamily/akshare>
> 官方文档：<https://akshare.akfamily.xyz/>
> 作者：AlbertAndKing（彭涛）· 语言：Python · License：MIT
> Stars ~12k · 持续维护中

---

## 简介

**AkShare** 是国内最知名的开源 **Python 财经数据接口库** 之一。它把分散在 A 股交易所、期货交易所、基金公司、央行、统计局、第三方数据服务商等几百个数据源里的数据，统一封装成 **"一行函数 + 一个 DataFrame"** 的调用方式。

项目的核心定位不是"做一个量化框架"，也不是"做一个回测系统"，而是做"**中国金融数据界的 requests**"——你想要什么数据，记住一个函数名，`import akshare as ak` 调一下就有。

作者彭涛（AlbertAndKing）从 2019 年开始维护，至今 6 年，仍在持续更新。配套官方文档站（akshare.akfamily.xyz）每个接口都给出了：

- 函数签名
- 参数说明
- 返回字段解释
- 可直接复制运行的示例代码

这在国内开源项目里非常少见——大多数爬虫类项目 README 一行示例、文档靠 issue 拼凑，AkShare 是真正做到了"文档级可用"。

---

## 为什么值得关注

国内做金融数据的库不少（Tushare Pro、Wind、聚宽、米筐、Ricequant……），AkShare 之所以在量化圈几乎人手一个，靠的是几个**结构性的优势**：

- **接口数量爆炸级**：超过 **1500+ 个公开接口**，覆盖股票 / 期货 / 期权 / 基金 / 债券 / 外汇 / 指数 / 加密货币 / 贵金属 / 农产品 / 宏观经济 / 政策公告 / 研报 / 影视票房 / 天气 等几十个垂直领域
- **零门槛上手**：免费、pip 装一下就能用，不需要注册账号、不需要 token、不需要付费会员；Tushare Pro 虽然也免费但有积分门槛，Wind / 聚宽要钱
- **数据原生是 pandas DataFrame**：拿到数据后直接 `.plot()`、`.to_csv()`、丢进 sklearn / backtrader / vectorbt 都能接得上
- **官方文档极其详细**：每个接口都标注了"数据源 URL、采集频率、字段含义、示例代码"，出问题自己就能定位
- **配套 HTTP 服务**：[aktools](https://github.com/akfamily/aktools) 可以把 AkShare 包成一个 HTTP API，给非 Python 端（前端、Java、Go、自动化脚本）调用
- **持续维护**：2025-2026 年仍保持月度更新，跟得上监管接口变更（如北交所、可转债新规）
- **License 友好**：MIT License，商用、二开、私有化部署都没问题

**一句话定位：** 当你想"临时快速拉一份某只股票 / 某个宏观指标 / 某类商品的历史数据"时，**AkShare 是最低摩擦的现成方案**。

---

## 涵盖领域

按类别整理当前覆盖的核心数据维度（仅列代表性接口）：

| 类别 | 典型接口 | 用途 |
|------|---------|------|
| **A 股行情** | `stock_zh_a_hist` / `stock_zh_a_spot_em` | 个股 / 全市场实时与历史 K 线 |
| **A 股基本面** | `stock_zh_a_indicator` / `stock_financial_report_sina` | 财务三大表、关键指标 |
| **A 股公告** | `stock_notice_report` | 巨潮资讯网公告全文 |
| **A 股研报** | `stock_research_report_em` | 个股研报列表 |
| **期货** | `futures_main_sina` / `futures_zh_daily_sina` | 商品期货主连合约 |
| **期权** | `option_sse_sina` / `option_dce_sina` | 三大商品 / 50ETF 期权 |
| **基金** | `fund_open_fund_info_em` / `fund_etf_fund_info_em` | 公募 / ETF / LOF |
| **指数** | `stock_zh_index_daily` / `index_stock_cons_weight_csindex` | 中证 / 国证 / 行业指数 |
| **宏观** | `macro_china_gdp` / `macro_china_cpi` / `macro_china_pmi` | GDP / CPI / PMI / M2 |
| **央行公开市场** | `macro_china_money_supply` / `bond_china_close_return` | 货币供应、国债收益率 |
| **外汇 / 黄金** | `forex_spot_em` / `futures_global_spot_em` | 即期汇率、伦敦金、银 |
| **数字货币** | `crypto_hist` / `crypto_name_map` | 主流币种历史 K 线 |
| **债券 / 逆回购** | `bond_zh_hs_daily` / `repo_rate` | 利率、回购 |
| **港美股** | `stock_hk_hist` / `stock_us_hist` | 港股 / 美股 |
| **特色** | `movie_boxoffice` / `weather_hefeng` / `car_sale_rank` | 票房、天气、汽车销量 |

> 数据源覆盖：新浪财经、东方财富、腾讯财经、和讯、雪球、中证指数、巨潮、上交所、深交所、郑商所、大商所、上期所、央行、国家统计局、海关总署、Choice、同花顺、FRED、CoinGecko 等。

---

## 如何使用

### 安装

一行命令搞定：

```bash
pip install akshare --upgrade
```

> 推荐 Python 3.10+，3.12 已稳定支持。如果安装慢可以用清华源：`pip install akshare -i https://pypi.tuna.tsinghua.edu.cn/simple`

### 30 秒上手示例

```python
import akshare as ak

# 1. 拉一只股票的历史 K 线（前复权）
df = ak.stock_zh_a_hist(
    symbol="000001",        # 平安银行
    period="daily",         # 日 K
    start_date="20240101",
    end_date="20251231",
    adjust="qfq"            # 前复权
)
print(df.head())
#           日期    开盘    收盘    最高    最低     成交量        成交额    振幅   涨跌幅  涨跌额  换手率
# 0  2024-01-02  9.32  9.45  9.51  9.30  784523  743562100  2.27  1.39  0.13  0.40
# ...

# 2. 拉全 A 股实时行情快照
spot_df = ak.stock_zh_a_spot_em()
print(spot_df.columns.tolist())
# ['序号', '代码', '名称', '最新价', '涨跌幅', '涨跌额', '成交量', '成交额', '振幅', '最高', '最低', '今开', '昨收', '量比', '换手率', '市盈率-动态', '市净率', '总市值', '流通市值', '涨速', '5分钟涨跌', '60日涨跌幅', '年初至今涨跌幅']

# 3. 拉中国 GDP 历史数据
gdp_df = ak.macro_china_gdp()
print(gdp_df.tail())
#           年份    国内生产总值-亿元    第一产业-亿元    第二产业-亿元    第三产业-亿元
# ...
```

### 配套服务：aktools

如果想让非 Python 端（比如前端、自动化脚本）也用上这些数据，可以装 [aktools](https://github.com/akfamily/aktools)：

```bash
pip install aktools
python -m aktools
```

启动后访问 `http://127.0.0.1:8080/docs` 就有 **Swagger UI**，所有 AkShare 接口都暴露成 HTTP API。

---

## 推荐用法

把 AkShare 当作"**取数层**"嵌入自己的工作流，能极大降低数据采集的维护成本：

- **量化研究 / 学术论文**：直接 `ak.stock_zh_a_hist()` + pandas + matplotlib，复现教科书策略、做因子检验
- **大屏可视化 / BI**：用 `stock_zh_a_spot_em()` 做实时行情大屏，配 Flask / FastAPI + ECharts
- **大模型 / RAG 数据源**：把宏观经济、行业指数喂给 LLM 做行业分析助手（这是我自己在用的一套方案）
- **自建投研工作流**：Notion / Obsidian + Python 脚本，每天定时拉自选股和大盘指数，写入本地 Markdown / SQLite
- **跨语言调用**：部署 aktools 暴露 HTTP API，给 Java / Go / Node 项目共享同一份数据
- **数据备份 / 历史归档**：定期 dump 关键接口的返回结果到本地，规避网站改版导致接口失效的风险

**避坑提示：**

1. **数据源可能改版**：AkShare 底层大多走爬虫，对方网站一改版接口就会临时挂掉，关注 [GitHub Issues](https://github.com/akfamily/akshare/issues) 第一时间知道修复进度
2. **频率限制**：实时接口请加 `time.sleep()`，高频调用会被目标网站封 IP
3. **不要用于实盘交易**：免费数据没有 SLA，不保证时效性和准确性，做决策请用 Wind / iFinD 这类专业终端
4. **大文件内存**：全市场 tick 级数据加载会爆内存，建议分批 / 用 `dtype` 优化

---

## 写在最后

AkShare 不是一个"炫技"的项目，它没有神经网络、没有 LLM、没有花哨的可视化界面。它就是一个**踏踏实实帮中国程序员解决"我想要数据"这个最朴素诉求**的工具库。

在中国的特殊金融环境下，很多数据要么不开放、要么散落在几十个网站、要么要付费才能拿到。AkShare 做的事情，本质上是把这种"摩擦"给熨平了——**一行 Python 代码，复制粘贴就能跑**。

如果你正在学量化、做研究、搭 dashboard、或者只是好奇"某只股票过去 5 年走势"，**直接 `pip install akshare`，五分钟之内就能拿到数据**。这可能是国内开源世界里，最容易被低估、也最容易在关键时刻救你一命的项目之一。

📌 **收藏清单**：⭐ 标 + 备用一份 `requirements.txt`，下一次需要"快速验证一个想法"时你会感谢现在的自己。

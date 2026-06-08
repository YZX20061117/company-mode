# 模式缓存目录

> 常见项目类型的预缓存模板。新项目匹配类型后，从缓存启动架构讨论，只做差异化调整。
> CEO 在 Phase 1 启动时检查：项目是否匹配某个缓存模式？如果是 → 加载模板作为讨论起点。

## 缓存模式列表

| 模式 | 适用场景 | 缓存内容 |
|------|---------|---------|
| [CLI 工具](#cli-工具) | 命令行工具、脚本工具 | Phase 1 架构框架 + 常见 DA 质疑清单 |
| [Web 全栈](#web-全栈) | 前后端分离 Web 应用 | Phase 1 架构框架 + 常见安全风险清单 |
| [API Server](#api-server) | 纯后端 API 服务 | Phase 1 架构框架 + 性能/扩展风险清单 |
| [静态网站](#静态网站) | 文档站、展示站、博客 | Phase 1 架构框架（简化） |

## 使用方式

1. Phase 1 启动时，CEO 判断项目类型
2. 加载对应缓存模板作为初始架构草案
3. CTO + PM 在此基础上做差异化调整（而非从零开始）
4. DA 的常见质疑清单作为审查加速器（验证差异化部分是否产生了新问题）
5. 模板中的"差异化检查点"是必须逐项确认的部分

---

## CLI 工具

### 预置架构框架

```
入口(CLI Args) → 命令解析(Command Router) → 业务逻辑(纯函数) → 输出(Stdout/File)
                        ↓
                  配置管理(Config Loader)
                   - 环境变量 (dotenv)
                   - 配置文件 (JSON/YAML/TOML)
                   - CLI 参数 (优先级最高)
                   - 默认值
```

### 预置技术选型

| 层 | 首选 | 备选 |
|----|------|------|
| CLI 框架 | Commander.js / Clap(Rust) / Cobra(Go) | yargs / clap-derive / flag |
| 配置 | dotenv + cosmiconfig | rc |
| 日志 | pino / tracing / zerolog | winston / log |
| 测试 | vitest / cargo-test / go-test | jest |
| 发布 | npm publish / cargo publish / go install | 二进制分发 |

### 常见 DA 质疑清单（Phase 1 快速审查）

- [ ] 为什么必须用 CLI 而不是配置文件 + 脚本？
- [ ] 错误信息对用户友好吗（不是堆栈追踪）？
- [ ] 支持 --dry-run / --verbose / --quiet 吗？
- [ ] 大文件输入时内存会爆吗（流式 vs 全量加载）？
- [ ] 跨平台兼容性（Windows 路径分隔符、换行符）？
- [ ] 敏感信息（Token/密码）通过 CLI 传入还是环境变量？

### 差异化检查点

- [ ] 命令树结构（子命令、参数、选项）
- [ ] 输入源（文件 / stdin / 网络 / 数据库）
- [ ] 输出格式（纯文本 / JSON / 表格 / 文件）
- [ ] 是否需要交互式（inquirer / dialoguer / promptui）

---

## Web 全栈

### 预置架构框架

```
Browser → CDN → Frontend SPA → API Gateway → Backend Service → Database
                    ↓                              ↓
                 Static Assets               Cache (Redis/Memcached)
                    ↓                              ↓
                 Object Storage              Message Queue
```

### 预置技术选型

| 层 | 首选 | 备选 |
|----|------|------|
| 前端框架 | React + Vite / Vue + Vite | Next.js / Nuxt / SvelteKit |
| 样式 | Tailwind CSS + CSS Variables | CSS Modules / Vanilla Extract |
| 状态管理 | TanStack Query + Zustand | Jotai / Pinia |
| 后端框架 | FastAPI / Express / Go-Fiber | NestJS / Django REST |
| 数据库 | PostgreSQL | MySQL / SQLite |
| 缓存 | Redis | Memcached |
| 部署 | Docker + Nginx | Vercel / Railway |

### 常见安全风险清单

- [ ] CSRF 保护
- [ ] XSS 防护（CSP + 输入净化）
- [ ] SQL 注入防护（参数化查询）
- [ ] 认证 Token 管理（HttpOnly Cookie vs LocalStorage）
- [ ] CORS 配置（不是 *）
- [ ] 速率限制
- [ ] 文件上传校验（类型、大小、病毒扫描）

### 差异化检查点

- [ ] 是否需要 SSR/SSG（SEO 关键？）
- [ ] 实时功能需求（WebSocket / SSE / 轮询）
- [ ] 多租户 / 权限模型
- [ ] 文件存储方案（本地 / S3 / 云存储）
- [ ] 搜索功能需求（全文检索 / Elasticsearch）
- [ ] 国际化需求
- [ ] 移动端适配需求

---

## API Server

### 预置架构框架

```
Client → API Gateway → Auth Middleware → Route Handler → Service Layer → Data Access → Database
                            ↓                    ↓              ↓
                       Rate Limiter         Validation      Cache Layer
                            ↓
                       Request Logging / Tracing
```

### 预置技术选型

| 层 | 首选 | 备选 |
|----|------|------|
| 框架 | FastAPI / Go-Fiber / Express | Hono / Gin |
| 认证 | JWT + Refresh Token | OAuth2 / API Key |
| 文档 | OpenAPI 自动生成 | 手写文档 |
| 数据库 ORM | Prisma / SQLAlchemy / GORM | Drizzle / sqlx |
| 消息队列 | Redis Bull / RabbitMQ | SQS / Kafka |
| 监控 | OpenTelemetry + Grafana | Datadog / Sentry |

### 常见性能/扩展风险清单

- [ ] 无索引的查询路径（N+1 问题）
- [ ] 连接池耗尽（数据库/Redis 连接上限）
- [ ] 无超时控制的第三方调用
- [ ] 内存泄漏（缓存无上限/事件监听器未释放）
- [ ] 无分页的列表查询
- [ ] 无幂等性的写操作

### 差异化检查点

- [ ] API 版本策略（URL / Header / Query）
- [ ] 批量操作支持
- [ ] Webhook / 回调机制
- [ ] 数据导入导出格式
- [ ] SLA 要求和多活部署需求

---

## 静态网站

### 预置架构框架（简化）

```
Markdown/Content → Static Site Generator → HTML/CSS/JS → CDN/Static Hosting
                         ↓
                    Build-time Data (APIs, CMS)
```

### 预置技术选型

| 层 | 首选 | 备选 |
|----|------|------|
| 框架 | Astro / Next.js Static / Hugo | 11ty / VitePress |
| 样式 | Tailwind CSS | UnoCSS |
| 托管 | Cloudflare Pages / Vercel | GitHub Pages |
| 内容 | Markdown + Frontmatter | MDX / Headless CMS |
| 图片 | 自动优化（框架内置） | Sharp 预处理 |

### 差异化检查点

- [ ] 内容更新频率（手动 / CMS / Git-based）
- [ ] 是否需要搜索（客户端搜索 / Algolia）
- [ ] 是否需要暗色模式
- [ ] SEO 要求（OG 标签、结构化数据、sitemap）

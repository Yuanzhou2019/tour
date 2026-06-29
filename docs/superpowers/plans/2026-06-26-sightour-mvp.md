# Sightour MVP 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在8-10周内交付面向英语系国家短期入境外籍游客的「上海试点」MVP一站式信息服务APP，纯信息工具+官方PGC口碑体系，无交易、无C2C撮合。

**Architecture:** Flutter跨端（iOS/Android）单体应用 + Node.js/NestJS后端API + 合规国内机房部署 + PostgreSQL/对象存储 + 高德地图官方英文SDK + Flutter intl国际化 + Hive离线缓存。MVP阶段全PGC官方产出，国内用户以游客模式匿名参与信息纠错。

**Tech Stack:**
- 前端：Flutter 3.x、Dart 3.x、flutter_bloc、go_router、dio、hive、flutter_intl、sentry
- 地图：高德地图Android/iOS官方SDK（含英文支持）
- 后端：NestJS、TypeScript、PostgreSQL 15、Redis、MinIO（对象存储）
- 内容后台：React + Ant Design Pro
- DevOps：Docker、GitHub Actions、阿里云合规机房
- 测试：flutter_test、integration_test、pytest（后端）

---

## 文档信息

| 项 | 内容 |
| :--- | :--- |
| 项目名称 | Sightour（外籍入境一站式服务APP） |
| 文档版本 | V1.0 |
| 对应PRD | Sightour.MD |
| 落地城市 | 上海市 |
| 计划周期 | 8-10周 |
| 创建日期 | 2026-06-26 |

---

## 一、Scope Check（范围检查）

PRD覆盖5个业务子系统 + 1个底层支撑体系。经评估，本MVP将所有P0功能视为一个完整可交付产品（口碑模块强耦合其他模块，单独拆分会破坏PGC内容链路）。建议：

- **主计划（本文件）**：覆盖全部MVP P0功能 + 配套PGC内容冷启动 + 合规上架
- **子计划（后续创建）**：
  - `2026-XX-XX-sightour-p1-ugc.md` — 阶段二UGC生态
  - `2026-XX-XX-sightour-p2-tasks.md` — 阶段三探店任务
  - `2026-XX-XX-sightour-content-pipeline.md` — PGC内容生产流水线

---

## 二、阶段划分与里程碑

### 阶段零：基础搭建（Week 1）
- 工程脚手架、CI流水线、合规框架启动
- 里程碑：可运行的Hello World双端APP + 后端API + CI绿

### 阶段一：系统基础 + 底层模块（Week 2-3）
- 多语言、单位切换、暗黑模式、离线框架
- 游客模式、隐私协议、纠错入口
- 里程碑：游客可完整切换中英文，体验所有外壳页面

### 阶段二：核心业务模块并行（Week 4-7）
- 入境准备、政策、清单、离线包
- 地图POI搜索、详情、公共出行指引
- 口碑评分、标签、榜单（依赖PGC内容同步就绪）
- 实用工具：汇率、紧急卡、常用语
- 里程碑：5大模块P0功能联调通过，dev环境跑通端到端

### 阶段三：PGC内容冷启动（Week 6-8，与阶段二并行）
- 政策类内容
- 上海TOP200 POI评分与标签
- 官方榜单与避坑清单
- 第三方口碑数据接入（TripAdvisor/Google公开星级）
- 里程碑：内容覆盖率≥95%，双人复核100%完成

### 阶段四：合规、上架与发布（Week 8-10）
- ICP备案、软著申请
- 内容审核后台
- 应用商店上架材料
- 内测→公测→正式发布
- 里程碑：iOS App Store + 国内主流安卓商店上架

---

## 三、文件结构

### 3.1 仓库布局（Monorepo）

```
sightour/
├── app/                              # Flutter APP
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart                  # MaterialApp + 路由
│   │   ├── core/                     # 核心能力
│   │   │   ├── theme/                # 主题、暗黑模式
│   │   │   ├── router/               # go_router配置
│   │   │   ├── network/              # dio封装、拦截器
│   │   │   ├── storage/              # Hive封装、离线缓存
│   │   │   ├── i18n/                 # intl配置
│   │   │   ├── analytics/            # 埋点
│   │   │   ├── error/                # 错误处理
│   │   │   └── permissions/          # 权限管理
│   │   ├── data/
│   │   │   ├── api/                  # API客户端
│   │   │   ├── models/               # 数据模型
│   │   │   └── repositories/         # 仓储实现
│   │   ├── domain/
│   │   │   ├── entities/             # 业务实体
│   │   │   └── usecases/             # 业务用例
│   │   ├── presentation/
│   │   │   ├── shared/               # 通用组件、Widget
│   │   │   └── modules/
│   │   │       ├── entry_prep/       # 入境准备
│   │   │       │   ├── bloc/
│   │   │       │   ├── pages/
│   │   │       │   └── widgets/
│   │   │       ├── map_transit/      # 地图与出行
│   │   │       │   ├── bloc/
│   │   │       │   ├── pages/
│   │   │       │   └── widgets/
│   │   │       ├── reputation/       # 目的地口碑
│   │   │       │   ├── bloc/
│   │   │       │   ├── pages/
│   │   │       │   └── widgets/
│   │   │       ├── utilities/        # 实用工具
│   │   │       │   ├── bloc/
│   │   │       │   ├── pages/
│   │   │       │   └── widgets/
│   │   │       └── user_account/     # 用户与账户
│   │   │           ├── bloc/
│   │   │           ├── pages/
│   │   │           └── widgets/
│   │   └── utils/
│   ├── assets/
│   │   ├── content/                  # 内置PGC内容（兜底）
│   │   ├── i18n/                     # ARB翻译文件
│   │   ├── images/
│   │   └── fonts/
│   ├── test/
│   │   ├── unit/
│   │   ├── widget/
│   │   └── integration/
│   ├── integration_test/
│   ├── pubspec.yaml
│   └── README.md
├── backend/                          # NestJS后端
│   ├── src/
│   │   ├── modules/
│   │   │   ├── policy/               # 政策内容
│   │   │   ├── poi/                  # POI数据
│   │   │   ├── reputation/           # 口碑数据
│   │   │   ├── checklist/            # 行前清单
│   │   │   ├── correction/           # 信息纠错
│   │   │   ├── user/                 # 用户（轻量）
│   │   │   └── content-pack/         # 离线资源包
│   │   ├── common/
│   │   ├── config/
│   │   └── main.ts
│   ├── test/
│   └── package.json
├── admin/                            # 内容审核后台（React）
│   ├── src/
│   │   ├── pages/
│   │   ├── components/
│   │   └── services/
│   └── package.json
├── content-ops/                      # PGC内容生产（脚本+模板）
│   ├── poi-template/
│   ├── policy-template/
│   └── README.md
├── docs/
│   ├── superpowers/
│   │   └── plans/                    # 实施计划（本文件）
│   ├── architecture/                 # 架构图
│   ├── compliance/                   # 合规材料
│   └── operations/                   # 运维手册
├── deploy/
│   ├── docker-compose.yml
│   └── k8s/
├── .github/
│   └── workflows/
└── README.md
```

### 3.2 设计原则

1. **按业务模块拆分**：5大模块独立目录，互不依赖实现细节，仅通过`domain`层交互
2. **按层切分**：`data` / `domain` / `presentation` 三层清晰
3. **离线优先**：所有读取路径先查本地Hive缓存，再异步同步API
4. **i18n原生**：所有UI文本走ARB资源，不允许硬编码字符串
5. **合规模板化**：敏感内容（政策、地图、合规）配置统一走模板，杜绝硬编码

---

## 四、任务列表

### 阶段零：基础搭建

#### Task 1：Monorepo工程初始化

**Files:**
- Create: `README.md`, `.gitignore`, `.editorconfig`
- Create: `app/`, `backend/`, `admin/`, `content-ops/`, `docs/`, `deploy/`

- [ ] **Step 1.1**：创建根目录README，定义仓库结构与开发规范
- [ ] **Step 1.2**：配置`.gitignore`覆盖Flutter/Node/IDE产物
- [ ] **Step 1.3**：初始化Git仓库并提交空结构
- [ ] **Step 1.4**：编写README快速启动指南

---

#### Task 2：Flutter APP脚手架

**Files:**
- Create: `app/pubspec.yaml`, `app/lib/main.dart`, `app/lib/app.dart`
- Create: `app/analysis_options.yaml`, `app/.metadata`

- [ ] **Step 2.1**：`flutter create app --org com.sightour --platforms ios,android`
- [ ] **Step 2.2**：配置`pubspec.yaml`，声明基础依赖：
  - flutter_bloc、go_router、dio、hive、hive_flutter、flutter_intl、sentry_flutter、package_info_plus、shared_preferences
  - dev：flutter_test、bloc_test、mocktail、integration_test
- [ ] **Step 2.3**：配置`analysis_options.yaml`，启用严格lint
- [ ] **Step 2.4**：实现`main.dart`初始化（Hive、intl、BlocObserver）
- [ ] **Step 2.5**：实现`app.dart`根MaterialApp（路由占位、中英文切换占位）
- [ ] **Step 2.6**：`flutter run`双端跑通Hello World
- [ ] **Step 2.7**：提交：`chore: scaffold flutter app`

---

#### Task 3：NestJS后端脚手架

**Files:**
- Create: `backend/package.json`, `backend/tsconfig.json`, `backend/nest-cli.json`
- Create: `backend/src/main.ts`, `backend/src/app.module.ts`

- [ ] **Step 3.1**：`nest new backend --package-manager npm`
- [ ] **Step 3.2**：安装核心依赖：typeorm、pg、redis、minio、class-validator、helmet、compression、passport-jwt
- [ ] **Step 3.3**：配置`AppModule`：ConfigModule、TypeModule(localhost)、RedisModule、健康检查
- [ ] **Step 3.4**：实现`/health`接口返回200
- [ ] **Step 3.5**：配置Swagger文档`/api/docs`
- [ ] **Step 3.6**：提交：`chore: scaffold nestjs backend`

---

#### Task 4：内容审核后台（React）

**Files:**
- Create: `admin/package.json`, `admin/vite.config.ts`
- Create: `admin/src/main.tsx`, `admin/src/App.tsx`

- [ ] **Step 4.1**：`npm create vite@latest admin -- --template react-ts`
- [ ] **Step 4.2**：安装Ant Design Pro Components、axios、react-router、zustand
- [ ] **Step 4.3**：实现登录页骨架（运营账号密码，MVP阶段硬编码1个管理员账号）
- [ ] **Step 4.4**：实现Layout（侧边栏 + 顶部 + 内容区）
- [ ] **Step 4.5**：提交：`chore: scaffold admin console`

---

#### Task 5：CI流水线（GitHub Actions）

**Files:**
- Create: `.github/workflows/app-ci.yml`, `.github/workflows/backend-ci.yml`

- [ ] **Step 5.1**：app-ci：lint → test → build apk（debug）
- [ ] **Step 5.2**：backend-ci：lint → test → build
- [ ] **Step 5.3**：admin-ci：lint → build
- [ ] **Step 5.4**：合PR前必须跑CI
- [ ] **Step 5.5**：提交：`ci: add github actions for app/backend/admin`

---

### 阶段一：系统基础 + 底层模块

#### Task 6：多语言（i18n）框架

**Files:**
- Create: `app/assets/i18n/app_en.arb`, `app/assets/i18n/app_zh.arb`
- Create: `app/lib/core/i18n/`

- [ ] **Step 6.1**：配置`flutter_intl`与ARB文件
- [ ] **Step 6.2**：建立中英文键值空间（按模块组织命名空间：`entry_*`, `map_*`, `rep_*`, `tool_*`, `user_*`, `common_*`）
- [ ] **Step 6.3**：实现语言切换Provider，默认跟随系统，首次启动引导选择英文
- [ ] **Step 6.4**：实现日期/地址/计量单位格式化（公里/英里、℃/℉）
- [ ] **Step 6.5**：编写widget测试验证切换正确性
- [ ] **Step 6.6**：提交：`feat(i18n): add bilingual framework`

---

#### Task 7：主题与暗黑模式

**Files:**
- Create: `app/lib/core/theme/`

- [ ] **Step 7.1**：定义品牌色（参考品牌指南）
- [ ] **Step 7.2**：实现`AppTheme.light/dark`，适配iOS/Android系统主题
- [ ] **Step 7.3**：Material3适配、字号/间距token化
- [ ] **Step 7.4**：暗黑模式切换测试
- [ ] **Step 7.5**：提交：`feat(theme): light/dark theme support`

---

#### Task 8：路由框架（go_router）

**Files:**
- Create: `app/lib/core/router/`

- [ ] **Step 8.1**：定义顶层路由表（ShellRoute + 模块子路由）
- [ ] **Step 8.2**：实现BottomNavigationBar 5个一级Tab：入境/地图/口碑/工具/我的
- [ ] **Step 8.3**：模块内深链：POI详情、政策详情、榜单详情
- [ ] **Step 8.4**：路由守卫：游客模式可访问全部P0功能
- [ ] **Step 8.5**：编写路由测试
- [ ] **Step 8.6**：提交：`feat(router): go_router with 5 main tabs`

---

#### Task 9：网络层（Dio封装）

**Files:**
- Create: `app/lib/core/network/`

- [ ] **Step 9.1**：实现单例Dio，base url走BuildConfig
- [ ] **Step 9.2**：实现拦截器：日志（dev）、错误统一处理、Auth（游客模式anonymousId）
- [ ] **Step 9.3**：超时、重试、刷新策略
- [ ] **Step 9.4**：单元测试覆盖拦截器
- [ ] **Step 9.5**：提交：`feat(network): dio with interceptors`

---

#### Task 10：本地存储（Hive）

**Files:**
- Create: `app/lib/core/storage/`

- [ ] **Step 10.1**：Hive box划分：`preferences`、`offline_pois`、`offline_policies`、`checklist_state`、`corrections_draft`
- [ ] **Step 10.2**：封装通用get/set/clear API
- [ ] **Step 10.3**：游客模式anonymousId生成与持久化
- [ ] **Step 10.4**：卸载清除逻辑（除preferences外随app卸载消失）
- [ ] **Step 10.5**：提交：`feat(storage): hive based local cache`

---

#### Task 11：游客模式与首次启动体验

**Files:**
- Create: `app/lib/presentation/modules/user_account/pages/onboarding.dart`
- Modify: `app/lib/main.dart`

- [ ] **Step 11.1**：首次启动引导：欢迎页 → 语言选择（默认英文） → 4步功能介绍 → 进入主页
- [ ] **Step 11.2**：不弹窗强制注册，全本地缓存即可
- [ ] **Step 11.3**：Onboarding完标记位写入preferences，二次启动跳过
- [ ] **Step 11.4**：编写integration test跑通首次启动流程
- [ ] **Step 11.5**：提交：`feat(onboarding): visitor mode first-launch`

---

#### Task 12：隐私政策与用户协议

**Files:**
- Create: `app/lib/presentation/shared/pages/privacy_policy.dart`
- Create: `app/lib/presentation/shared/pages/user_agreement.dart`
- Create: `docs/compliance/privacy-policy-zh.md`, `docs/compliance/privacy-policy-en.md`

- [ ] **Step 12.1**：撰写中英文双语隐私政策与用户协议（法务参与）
- [ ] **Step 12.2**：Onboarding末步展示同意页
- [ ] **Step 12.3**：「我的」页面提供入口可查看
- [ ] **Step 12.4**：明确最小必要原则、不收集敏感信息
- [ ] **Step 12.5**：提交：`feat(legal): bilingual privacy policy and user agreement`

---

#### Task 13：信息纠错通用入口

**Files:**
- Create: `app/lib/presentation/shared/widgets/correction_entry.dart`
- Create: `app/lib/presentation/modules/user_account/pages/correction_submit.dart`
- Create: `backend/src/modules/correction/`

- [ ] **Step 13.1**：每个POI详情、政策页底部悬浮「信息纠错」按钮
- [ ] **Step 13.2**：纠错表单：问题类型（下拉）、问题描述（多行）、补充图片（选填）、联系邮箱（选填）
- [ ] **Step 13.3**：后端API：`POST /api/v1/corrections`，落库到`corrections`表
- [ ] **Step 13.4**：游客模式可提交，anonymousId绑定
- [ ] **Step 13.5**：提交成功Toast「我们已收到，48小时内反馈」
- [ ] **Step 13.6**：后端单测、APP widget测试
- [ ] **Step 13.7**：提交：`feat(correction): universal info correction entry`

---

#### Task 14：达人招募预埋入口

**Files:**
- Create: `app/lib/presentation/modules/user_account/pages/daniu_recruit.dart`

- [ ] **Step 14.1**：纠错页底部预埋「成为双语达人」入口
- [ ] **Step 14.2**：表单：邮箱/微信/手机（选填）、意向领域（多选）、自我介绍（200字内）
- [ ] **Step 14.3**：后端API：`POST /api/v1/recruitments`，仅收集信息，不生成任何权益
- [ ] **Step 14.4**：隐私说明：明确二期种子储备用途
- [ ] **Step 15.5**：提交：`feat(recruit): daniu (bilingual expert) recruit entry`

---

### 阶段二：核心业务模块

#### Task 15：入境准备 - 政策查询

**Files:**
- Create: `backend/src/modules/policy/`
- Create: `app/lib/presentation/modules/entry_prep/pages/policy_home.dart`
- Create: `app/lib/presentation/modules/entry_prep/pages/policy_detail.dart`

- [ ] **Step 15.1**：后端数据模型：Policy { id, country, category, title_zh, title_en, content_zh, content_en, source_url, source_name, updated_at }
- [ ] **Step 15.2**：后端API：`GET /api/v1/policies?country=&category=`、`GET /api/v1/policies/:id`
- [ ] **Step 15.3**：种子数据：15天免签政策、144小时过境免签、海关申报、禁止携带物品清单
- [ ] **Step 15.4**：APP端：按国籍选择 → 分类展示 → 详情页含官方原文跳转链接
- [ ] **Step 15.5**：详情页底部统一免责声明
- [ ] **Step 15.6**：中英文一键切换
- [ ] **Step 15.7**：后端单测、APP widget测试
- [ ] **Step 15.8**：提交：`feat(policy): country-based policy query`

---

#### Task 16：入境准备 - 行前必备清单

**Files:**
- Create: `app/lib/presentation/modules/entry_prep/pages/checklist.dart`
- Create: `app/lib/data/models/checklist_item.dart`

- [ ] **Step 16.1**：内置5大类清单：手机号预约、外卡绑定、漫游方案、入境物品、其他
- [ ] **Step 16.2**：每项含标题、详细步骤、官方跳转链接
- [ ] **Step 16.3**：支持勾选标记完成状态，本地缓存
- [ ] **Step 16.4**：离线可用（内容内置）
- [ ] **Step 16.5**：进度展示「已完成 X / Y」
- [ ] **Step 16.6**：widget测试覆盖勾选状态持久化
- [ ] **Step 16.7**：提交：`feat(checklist): pre-arrival checklist`

---

#### Task 17：入境准备 - 离线资源预下载

**Files:**
- Create: `app/lib/presentation/modules/entry_prep/pages/offline_download.dart`
- Create: `backend/src/modules/content-pack/`

- [ ] **Step 17.1**：后端：`GET /api/v1/content-packs/:city/:version`，返回离线包清单与下载URL
- [ ] **Step 17.2**：离线包内容：上海离线地图包（高德）、POI数据、政策、榜单、常用语
- [ ] **Step 17.3**：APP端：下载管理页面，按包分类展示大小/状态/进度
- [ ] **Step 17.4**：下载后存储到Hive + 文件系统
- [ ] **Step 17.5**：联网时自动检测版本更新并提示
- [ ] **Step 17.6**：下载失败重试、Wi-Fi下自动下载选项
- [ ] **Step 17.7**：提交：`feat(offline): content pack pre-download`

---

#### Task 18：地图 - 高德SDK接入

**Files:**
- Create: `app/lib/presentation/modules/map_transit/pages/map_home.dart`
- Modify: `app/pubspec.yaml`

- [ ] **Step 18.1**：Android：申请高德Key，配置`AndroidManifest.xml`权限
- [ ] **Step 18.2**：iOS：申请高德Key，配置`Info.plist`权限说明文案
- [ ] **Step 18.3**：引入`amap_flutter_map`官方SDK
- [ ] **Step 18.4**：地图主页：定位、缩放、POI搜索、路线规划入口
- [ ] **Step 18.5**：英文模式开启（高德支持英文显示）
- [ ] **Step 18.6**：严禁使用境外地图SDK，合规自检清单写入`docs/compliance/`
- [ ] **Step 18.7**：integration test：地图加载、定位mock
- [ ] **Step 18.8**：提交：`feat(map): integrate amap official sdk`

---

#### Task 19：地图 - POI搜索与详情

**Files:**
- Create: `app/lib/presentation/modules/map_transit/pages/poi_search.dart`
- Create: `app/lib/presentation/modules/map_transit/pages/poi_detail.dart`

- [ ] **Step 19.1**：搜索页：关键词输入、周边推荐、分类筛选（餐饮/购物/景点/交通）
- [ ] **Step 19.2**：结果列表展示口碑评分+2个核心标签
- [ ] **Step 19.3**：详情页：英文名称、地址、营业时间、官方联系方式、交通指引
- [ ] **Step 19.4**：嵌入口碑评分专区入口
- [ ] **Step 19.5**：详情页底部「信息纠错」入口
- [ ] **Step 19.6**：不提供预订/下单入口，仅附官方渠道跳转
- [ ] **Step 19.7**：widget测试覆盖搜索→详情跳转
- [ ] **Step 19.8**：提交：`feat(poi): search and detail`

---

#### Task 20：地图 - 口碑嵌入

**Files:**
- Modify: `app/lib/presentation/modules/map_transit/pages/poi_search.dart`
- Modify: `app/lib/presentation/modules/map_transit/pages/poi_detail.dart`

- [ ] **Step 20.1**：搜索结果按口碑评分排序、按标签筛选
- [ ] **Step 20.2**：筛选标签：可接待外宾、支持外卡支付、英文服务、素食友好、24小时营业
- [ ] **Step 20.3**：详情页口碑区显示综合评分+5维度小评分
- [ ] **Step 20.4**：口碑区点击跳完整口碑页
- [ ] **Step 20.5**：PGC数据从后端API获取（`GET /api/v1/pois/:id/reputation`）
- [ ] **Step 20.6**：离线模式下显示已缓存口碑
- [ ] **Step 20.7**：提交：`feat(map): reputation embedded in search`

---

#### Task 21：地图 - 公共出行操作指南

**Files:**
- Create: `app/lib/presentation/modules/map_transit/pages/transit_guide_home.dart`
- Create: `app/lib/presentation/modules/map_transit/pages/transit_subway.dart`
- Create: `app/lib/presentation/modules/map_transit/pages/transit_hsr.dart`
- Create: `app/lib/presentation/modules/map_transit/pages/transit_taxi.dart`

- [ ] **Step 21.1**：三大场景入口：地铁、高铁、打车
- [ ] **Step 21.2**：每个场景：购票流程截图、乘车码开通步骤、外卡绑定步骤、防坑提示
- [ ] **Step 21.3**：图文结合，英文为主
- [ ] **Step 21.4**：仅做操作说明，不跳转交易页
- [ ] **Step 21.5**：离线可用（内容内置）
- [ ] **Step 21.6**：提交：`feat(transit): public transport guide`

---

#### Task 22：口碑 - 多维度评分（核心）

**Files:**
- Create: `backend/src/modules/reputation/`
- Create: `app/lib/presentation/modules/reputation/pages/reputation_detail.dart`
- Create: `app/lib/presentation/modules/reputation/widgets/score_breakdown.dart`

- [ ] **Step 22.1**：后端数据模型：Reputation { poi_id, overall_score, foreign_friendly, language_support, payment_ease, authenticity, value, official_verified, updated_at }
- [ ] **Step 22.2**：后端API：`GET /api/v1/pois/:id/reputation`、`GET /api/v1/reputations?tag=&sort=`
- [ ] **Step 22.3**：APP端：5维度独立打分展示（雷达图/进度条）
- [ ] **Step 22.4**：标注「官方核验」标识，底部说明评定依据
- [ ] **Step 22.5**：MVP阶段全PGC，后台录入
- [ ] **Step 22.6**：严禁收受商家费用篡改评分（运营制度兜底）
- [ ] **Step 22.7**：单测覆盖评分展示与排序
- [ ] **Step 22.8**：提交：`feat(reputation): multi-dimensional scoring`

---

#### Task 23：口碑 - 标签体系

**Files:**
- Create: `app/lib/presentation/modules/reputation/widgets/tag_chip.dart`
- Modify: `app/lib/presentation/modules/reputation/pages/reputation_detail.dart`

- [ ] **Step 23.1**：三类标签：
  - 正向（绿色）：支持外卡支付、英文菜单、清真认证、素食友好、无障碍设施、24小时营业
  - 提示（黄色）：需提前预约、仅收现金、排队较长、无英文服务
  - 风险（红色）：不推荐、外宾资质存疑、投诉较多
- [ ] **Step 23.2**：标签在搜索列表、详情页、榜单页同步展示
- [ ] **Step 23.3**：后台管理：标签字典维护
- [ ] **Step 23.4**：widget测试覆盖标签颜色与点击
- [ ] **Step 23.5**：提交：`feat(reputation): tag system`

---

#### Task 24：口碑 - 官方精选榜单

**Files:**
- Create: `app/lib/presentation/modules/reputation/pages/rank_home.dart`
- Create: `app/lib/presentation/modules/reputation/pages/rank_detail.dart`
- Create: `backend/src/modules/reputation/rank.service.ts`

- [ ] **Step 24.1**：三大类榜单：
  - 品类垂直榜：餐饮TOP20、购物TOP10、景点TOP15等
  - 场景化榜：亲子友好、情侣约会、商务接待、独行安全
  - 避坑预警清单（红色高亮）
- [ ] **Step 24.2**：榜单数据从后端`GET /api/v1/ranks/:category`获取
- [ ] **Step 24.3**：每榜单标注更新时间，固定月度更新机制
- [ ] **Step 24.4**：避坑清单单独成模块
- [ ] **Step 24.5**：后台：榜单编辑、排序、发布时间管理
- [ ] **Step 24.6**：提交：`feat(reputation): curated rank lists`

---

#### Task 25：口碑 - 真实体验提示

**Files:**
- Create: `app/lib/presentation/modules/reputation/widgets/experience_tip.dart`
- Modify: `app/lib/presentation/modules/reputation/pages/reputation_detail.dart`

- [ ] **Step 25.1**：详情页顶部高亮核心提示（红色/黄色/绿色chip）
- [ ] **Step 25.2**：正文短句式客观体验说明（3-5条）
- [ ] **Step 25.3**：通用避坑指南页（不打POI标）
- [ ] **Step 25.4**：全部PGC产出，客观陈述事实，无情绪化
- [ ] **Step 25.5**：双人复核文案（运营制度）
- [ ] **Step 25.6**：提交：`feat(reputation): experience tips`

---

#### Task 26：口碑 - 第三方口碑合规引用

**Files:**
- Create: `backend/src/modules/reputation/third-party.service.ts`
- Modify: `app/lib/presentation/modules/reputation/pages/reputation_detail.dart`

- [ ] **Step 26.1**：后端：定时任务拉取TripAdvisor/Google Maps公开星级（仅整体评分）
- [ ] **Step 26.2**：手动录入运营后台，不抓评论内容、不内嵌境外页、不提供外链跳转
- [ ] **Step 26.3**：展示区域明确标注「数据来源：TripAdvisor，采集时间YYYY-MM-DD」
- [ ] **Step 26.4**：拉取API时严格控制频率，不批量抓评论
- [ ] **Step 26.5**：法务复核境外平台引用合规性
- [ ] **Step 26.6**：提交：`feat(reputation): third-party rating citation`

---

#### Task 27：实用工具 - 汇率换算

**Files:**
- Create: `app/lib/presentation/modules/utilities/pages/exchange_rate.dart`
- Create: `backend/src/modules/utilities/exchange-rate.service.ts`

- [ ] **Step 27.1**：对接合规汇率API（央行/聚合数据）
- [ ] **Step 27.2**：支持主流货币：USD/EUR/GBP/JPY/KRW/AUD等
- [ ] **Step 27.3**：实时换算 + 离线缓存最近一次汇率
- [ ] **Step 27.4**：APP端：金额输入 → 即时换算 → 显示汇率来源与时间
- [ ] **Step 27.5**：后端定时刷新汇率（每30分钟）
- [ ] **Step 27.6**：单测覆盖换算逻辑
- [ ] **Step 27.7**：提交：`feat(utilities): exchange rate converter`

---

#### Task 28：实用工具 - 紧急信息卡

**Files:**
- Create: `app/lib/presentation/modules/utilities/pages/emergency_card.dart`

- [ ] **Step 28.1**：内置数据：110/120/119、出入境管理部门、主要国家驻沪领事馆
- [ ] **Step 28.2**：一键拨打（iOS/Android权限处理）
- [ ] **Step 28.3**：离线可查看
- [ ] **Step 28.4**：中英文切换展示
- [ ] **Step 28.5**：提交：`feat(utilities): emergency info card`

---

#### Task 29：实用工具 - 常用语手册

**Files:**
- Create: `app/lib/presentation/modules/utilities/pages/phrases_home.dart`
- Create: `app/lib/presentation/modules/utilities/pages/phrases_category.dart`
- Create: `app/assets/content/phrases.json`

- [ ] **Step 29.1**：分类：入关、打车、就餐、就医、紧急、其他
- [ ] **Step 29.2**：每条短语：英文 + 中文 + 拼音标注
- [ ] **Step 29.3**：支持点击朗读（接入TTS）
- [ ] **Step 29.4**：离线可用
- [ ] **Step 29.5**：提交：`feat(utilities): phrase book`

---

### 阶段三：PGC内容冷启动

#### Task 30：PGC内容 - 政策内容生产

**Files:**
- Create: `content-ops/policy-template/`
- Create: `backend/seeds/policies.json`

- [ ] **Step 30.1**：基于官方公开信息整理（国家移民管理局、上海海关、文旅部）
- [ ] **Step 30.2**：双人交叉核验100%准确
- [ ] **Step 30.3**：覆盖国家：美/英/加/澳/德/法/日/韩/新等英语系+主流客源国
- [ ] **Step 30.4**：覆盖类别：15天免签、144小时过境、普通签证、海关申报、禁止物品
- [ ] **Step 30.5**：数据落入数据库
- [ ] **Step 30.6**：提交：`content(policy): initial policy corpus`

---

#### Task 31：PGC内容 - 上海TOP200 POI

**Files:**
- Create: `content-ops/poi-template/poi.schema.json`
- Create: `backend/seeds/pois.json`

- [ ] **Step 31.1**：覆盖范围：上海核心商圈（南京西路/淮海路/陆家嘴/徐家汇等）、景点（外滩/豫园/迪士尼等）、交通枢纽（浦东/虹桥机场、上海站等）
- [ ] **Step 31.2**：每个POI完整字段：英文名、中文名、地址、电话、营业时间、坐标（高德提供）、分类、5维度评分、标签、真实体验提示
- [ ] **Step 31.3**：双人实地走访+线上资料复核
- [ ] **Step 31.4**：严禁收录无外宾接待资质场所（住宿红线）
- [ ] **Step 31.5**：图片：每个POI至少3张实拍图（自营或官方授权）
- [ ] **Step 31.6**：导入数据库并联调展示
- [ ] **Step 31.7**：提交：`content(poi): shanghai top 200 pois`

---

#### Task 32：PGC内容 - 官方榜单

**Files:**
- Create: `content-ops/rank-template/`
- Create: `backend/seeds/ranks.json`

- [ ] **Step 32.1**：餐饮TOP20（按菜系细分）
- [ ] **Step 32.2**：购物TOP10
- [ ] **Step 32.3**：景点TOP15
- [ ] **Step 32.4**：场景榜：亲子/情侣/商务/独行 各5-10个
- [ ] **Step 32.5**：避坑清单：至少20个常见坑点（黑车/假景点/天价菜单等）
- [ ] **Step 32.6**：榜单内附推荐理由短文（英文）
- [ ] **Step 32.7**：双人复核
- [ ] **Step 32.8**：提交：`content(rank): curated rank lists`

---

#### Task 33：PGC内容 - 常用语手册数据

**Files:**
- Create: `app/assets/content/phrases.json`

- [ ] **Step 33.1**：入关类：护照检查、海关申报、入境卡填写
- [ ] **Step 33.2**：打车类：目的地说明、支付方式、投诉
- [ ] **Step 33.3**：就餐类：点餐、退餐、过敏询问
- [ ] **Step 33.4**：就医类：症状描述、医院指引、买药
- [ ] **Step 33.5**：紧急类：报警、求助、丢护照
- [ ] **Step 33.6**：每类至少10-20条短语
- [ ] **Step 33.7**：提交：`content(phrases): phrase book corpus`

---

#### Task 34：内容审核后台 - 完整功能

**Files:**
- Create: `admin/src/pages/PoiManagement/`
- Create: `admin/src/pages/PolicyManagement/`
- Create: `admin/src/pages/RankManagement/`
- Create: `admin/src/pages/CorrectionReview/`
- Create: `admin/src/pages/RecruitmentList/`

- [ ] **Step 34.1**：登录鉴权（JWT）
- [ ] **Step 34.2**：POI管理：列表、新增、编辑、批量导入、标签字典
- [ ] **Step 34.3**：政策管理：列表、新增、编辑、来源链接校验
- [ ] **Step 34.4**：榜单管理：拖拽排序、定时发布
- [ ] **Step 34.5**：纠错审核：列表、采纳/驳回、采纳后通知（邮件）
- [ ] **Step 34.6**：招募列表：导出、双语达人打标
- [ ] **Step 34.7**：双人复核工作流（编辑-复核双账号）
- [ ] **Step 34.8**：操作日志、统计数据（POI数量、纠错量、采纳率）
- [ ] **Step 34.9**：提交：`feat(admin): content review console`

---

### 阶段四：合规、上架与发布

#### Task 35：合规资质备案

**Files:**
- Create: `docs/compliance/`

- [ ] **Step 35.1**：域名ICP备案
- [ ] **Step 35.2**：服务器部署于国内合规机房（阿里云/腾讯云华东节点）
- [ ] **Step 35.3**：申请《计算机软件著作权登记证书》
- [ ] **Step 35.4**：产品类目定位「旅游信息服务」
- [ ] **Step 35.5**：启动等保二级备案准备
- [ ] **Step 35.6**：合规自检清单100%勾选（参考PRD §4.1-4.2）

---

#### Task 36：隐私与数据保护实施

**Files:**
- Modify: `app/lib/core/permissions/`
- Modify: `app/lib/presentation/modules/user_account/pages/settings.dart`

- [ ] **Step 36.1**：定位/存储/相机权限单独弹窗申请，明确告知用途
- [ ] **Step 36.2**：拒绝权限不影响核心功能（游客模式完全可用）
- [ ] **Step 36.3**：账号注销/数据删除入口（MVP预留，P1实现）
- [ ] **Step 36.4**：用户数据全部境内存储
- [ ] **Step 36.5**：HTTPS全链路、敏感字段加密

---

#### Task 37：应用商店上架准备

**Files:**
- Create: `docs/store-listing/`

- [ ] **Step 37.1**：iOS App Store：英文应用名、英文描述、关键词、截图（含英文截图）
- [ ] **Step 37.2**：iOS：ATT框架合规声明（无广告/不追踪）
- [ ] **Step 37.3**：Android（华为/小米/OPPO/VIVO/应用宝）：如实申报涉外服务属性
- [ ] **Step 37.4**：隐私政策URL、应用权限说明
- [ ] **Step 37.5**：上架审核问题FAQ
- [ ] **Step 37.6**：提交审核 → 等审核 → 处理Review反馈

---

#### Task 38：种子用户招募与冷启动

**Files:**
- Create: `docs/operations/cold-start.md`

- [ ] **Step 38.1**：海外渠道流量接入：Tripadvisor论坛、Reddit r/shanghai、YouTube旅游博主合作（待商务侧启动）
- [ ] **Step 38.2**：国内社群：留学生社群、外语社群、本地生活KOL定向邀请
- [ ] **Step 38.3**：纠错激励：上线初期采纳纠错给予虚拟荣誉
- [ ] **Step 38.4**：邮件反馈渠道：support@sightour.com，工作日24小时响应
- [ ] **Step 38.5**：数据看板：DAU/留存/口碑模块点击率/榜单访问率/纠错提交量

---

#### Task 39：MVP端到端联调与发布

- [ ] **Step 39.1**：全量端到端联调（5模块全链路）
- [ ] **Step 39.2**：性能验证：冷启动≤2秒、POI搜索≤1秒
- [ ] **Step 39.3**：离线场景验证：100%核心功能可用
- [ ] **Step 39.4**：包体积验证：Android≤200MB、iOS≤250MB
- [ ] **Step 39.5**：灰度发布：内部员工→种子用户→公测
- [ ] **Step 39.6**：正式发布
- [ ] **Step 39.7**：发布复盘文档

---

## 五、关键依赖与风险

### 5.1 关键外部依赖

| 依赖 | 类型 | 风险 | 应对 |
| :--- | :--- | :--- | :--- |
| 高德地图Key | 资质 | 申请周期1-2周 | Week1启动申请 |
| ICP备案 | 资质 | 周期2-3周 | Week1启动 |
| 软著 | 资质 | 周期1-2月 | Week1启动，月内拿证 |
| 央行汇率API | 数据 | 接口稳定性 | 接入备用源 |
| TripAdvisor/Google | 数据 | 引用合规 | 法务前置确认 |

### 5.2 关键风险

| 风险 | 影响 | 缓解 |
| :--- | :--- | :--- |
| 合规审批延期 | 上架延期 | Week1并行启动、预留缓冲 |
| PGC内容不足 | 用户体验差 | 运营Week3入场，Week6-8集中生产 |
| 第三方口碑引用合规 | 法务风险 | 仅引用公开星级、不抓评论、不外链 |
| 离线包体积过大 | 下载体验差 | 分包下载、按需下载、压缩优化 |

---

## 六、Spec 自检

### 6.1 PRD P0覆盖度

| PRD P0功能 | 对应Task |
| :--- | :--- |
| 入境-政策查询 | Task 15 |
| 入境-行前清单 | Task 16 |
| 入境-离线资源下载 | Task 17 |
| 地图-合规SDK | Task 18 |
| 地图-POI搜索详情 | Task 19 |
| 地图-口碑嵌入 | Task 20 |
| 地图-公共出行指引 | Task 21 |
| 口碑-多维度评分 | Task 22 |
| 口碑-标签体系 | Task 23 |
| 口碑-官方榜单 | Task 24 |
| 口碑-真实体验提示 | Task 25 |
| 口碑-第三方引用 | Task 26 |
| 工具-汇率 | Task 27 |
| 工具-紧急卡 | Task 28 |
| 工具-常用语 | Task 29 |
| 用户-游客模式 | Task 11 |
| 用户-纠错入口 | Task 13 |
| 用户-达人招募预埋 | Task 14 |
| 系统-多语言 | Task 6 |
| 系统-暗黑/单位 | Task 7 |
| 系统-离线缓存 | Task 10/17 |
| 系统-审核后台 | Task 34 |
| 合规-资质备案 | Task 35 |
| 合规-隐私协议 | Task 12/36 |
| 合规-上架 | Task 37 |
| PGC冷启动-政策 | Task 30 |
| PGC冷启动-POI TOP200 | Task 31 |
| PGC冷启动-榜单 | Task 32 |
| PGC冷启动-常用语 | Task 33 |

**结论：PRD §3.1-3.6全部P0功能均已映射。**

### 6.2 合规红线自检

- [x] 严禁接入境外地图SDK → Task 18高德SDK
- [x] 严禁自行采集坐标 → 全部使用高德SDK数据
- [x] 严禁标注敏感地点 → POI内容双人复核（Task 31）
- [x] 严禁推荐无资质住宿 → 住宿名录接入官方渠道
- [x] 严禁虚假政策 → 双人复核（Task 30）
- [x] 严禁代办签证 → 仅做信息展示+官方跳转
- [x] 严禁数据出境 → 境内服务器、隐私协议明确
- [x] 严禁批量抓境外评论 → Task 26仅引用公开星级
- [x] 严禁境外网站外链 → Task 26/19不提供外链跳转
- [x] 严禁收受商家费用篡改评分 → 运营制度兜底
- [x] 严禁UGC未经审核 → MVP无UGC

### 6.3 验收指标定义

- 转化：境外渠道流量→下载≥15%，下载→核心功能启动≥60%
- 留存：3日≥30%、7日≥15%
- 功能：口碑模块点击率≥40%、榜单访问率≥30%、日均纠错≥20条
- 合规：零重大合规风险、应用商店审核一次通过

---

## 七、后续阶段计划（占位）

### 阶段二：P1 UGC生态（计划占位）
- 多渠道注册登录
- 用户分层与身份标识
- 双视角结构化评价
- 本地居民小贴士
- 轻量问答互助
- 信用分体系

### 阶段三：P2 探店任务（计划占位）
- 任务发布/接单/交付
- IM即时通讯
- 担保支付与分账
- 任务内容自动沉淀口碑

详见后续子计划文档。

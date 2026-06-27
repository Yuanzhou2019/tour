# Sightour

外籍入境一站式服务 APP（上海试点）— 信息工具 + 官方 PGC 口碑。

> 当前阶段：**阶段零（脚手架）**。业务代码从阶段一开始。

## 仓库结构

```
sightour/
├── app/            Flutter APP（iOS / Android）
├── backend/        NestJS API
├── admin/          React + Ant Design Pro 内容审核后台
├── content-ops/    PGC 内容生产（阶段三）
├── deploy/         Docker Compose（postgres / redis / minio）
├── docs/           设计文档与实施计划
└── prototype/      设计原型 HTML
```

## 快速启动

### 前置依赖

| 工具 | 版本 | 校验 |
| --- | --- | --- |
| Flutter SDK | ≥ 3.24 | `flutter --version` |
| Node.js | ≥ 20 | `node --version` |
| npm | ≥ 10 | `npm --version` |
| Git | ≥ 2.30 | `git --version` |

### Flutter APP

```bash
cd app
flutter pub get
dart analyze
flutter test
```

### 后端

```bash
cd backend
npm install
npm run build
npm test
```

### Admin

```bash
cd admin
npm install
npm run build
```

## 设计文档

- [阶段零脚手架设计](docs/superpowers/specs/2026-06-27-sightour-stage0-scaffold-design.md)
- [MVP 实施计划](docs/superpowers/plans/2026-06-26-sightour-mvp.md)
- [前端架构规范](docs/superpowers/specs/2026-06-26-sightour-frontend-architecture.md)
- [状态设计规范](docs/superpowers/specs/2026-06-26-sightour-states-spec.md)
- [设计系统](docs/superpowers/specs/2026-06-26-sightour-design-system.md)

## 贡献

- 不提交 `node_modules/`、`build/`、`coverage/`、`.env`
- 提交前跑 `dart format .`（app）、`npm run lint`（backend / admin）
- 一次 PR 聚焦一个 Task
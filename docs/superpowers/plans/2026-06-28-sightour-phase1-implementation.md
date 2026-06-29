# Sightour 第一阶段实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 4 周内交付"纯中国入境信息工具"第一阶段：7 大功能模块端到端跑通（前端 + 真后端 + DB + Admin + PGC 内容）。

**Architecture:** Flutter 跨端 + NestJS 后端 + PostgreSQL + MinIO + React Admin；多端共用 TypeScript/Dart；分 4 周冲刺：W1 后端骨架、 W2 Admin 后台、 W3 前端详情页 + 联通、 W4 测试 + 收尾。

**Tech Stack:**
- Frontend: Flutter 3.x、Dart 3.x、flutter_bloc、go_router、dio、hive、flutter_intl
- Backend: NestJS 10、TypeScript、TypeORM 0.3、PostgreSQL 15、class-validator、helmet、passport-jwt
- Admin: React 18 + Ant Design Pro + Vite + axios + zustand
- PGC: JSON 种子 + idempotent seed 脚本

**参考文档**：
- 范围定义：`docs/superpowers/plans/2026-06-28-sightour-mvp-pure-info-tool.md`
- 进度快照：`docs/progress-snapshot-2026-06-28.md`
- 原始 39 Task 计划：`docs/superpowers/plans/2026-06-26-sightour-mvp.md`

---

## 0. 文件结构（实施前先确认）

### 0.1 后端新增文件

```
backend/src/
├── modules/
│   ├── policy/
│   │   ├── entities/policy.entity.ts          [新增]
│   │   ├── policy.service.ts                  [改：接 Repository]
│   │   ├── policy.controller.ts               [保持]
│   │   ├── policy.module.ts                   [改：注册 Entity]
│   │   └── dto/                               [新增]
│   │       ├── query-policy.dto.ts
│   │       └── create-policy.dto.ts
│   ├── checklist/                             [全部新增，结构同 policy]
│   ├── poi/                                   [结构同 policy]
│   ├── reputation/                            [结构同 policy]
│   ├── discover/                              [新增 module]
│   │   ├── entities/{discover-card,rank}.entity.ts
│   │   ├── discover.service.ts
│   │   ├── discover.controller.ts
│   │   └── discover.module.ts
│   ├── tools/                                 [新增 module]
│   │   ├── entities/{emergency-contact,phrase,fx-rate}.entity.ts
│   │   ├── tools.service.ts
│   │   ├── tools.controller.ts
│   │   └── tools.module.ts
│   ├── correction/                            [补全 POST]
│   │   ├── entities/correction.entity.ts      [新增]
│   │   ├── correction.service.ts              [改：接 Repository]
│   │   ├── correction.controller.ts           [改：加 POST/PATCH]
│   │   └── correction.module.ts
│   └── user/                                  [补全 anonymous]
│       ├── entities/user.entity.ts            [新增]
│       ├── user.service.ts                    [改]
│       ├── user.controller.ts                 [改]
│       └── user.module.ts
├── common/
│   ├── interceptors/anonymous-id.interceptor.ts   [新增]
│   ├── guards/                                 [新增 admin-jwt.guard.ts]
│   └── decorators/current-user.decorator.ts      [新增]
├── config/
│   └── typeorm.config.ts                       [改：register 所有 Entity]
└── seeds/
    ├── seed.ts                                 [新增：启动 hook]
    ├── policies.json
    ├── checklists.json
    ├── pois.json
    ├── reputations.json
    ├── tags.json
    ├── discover.json
    ├── ranks.json
    ├── phrases.json
    ├── emergency.json
    └── fx-rates.json
```

### 0.2 前端新增文件

```
app/lib/features/
├── prepare/presentation/pages/
│   ├── policy_detail_page.dart                 [新增]
│   └── checklist_page.dart                     [新增]
├── poi/                                        [新增整个 feature]
│   ├── domain/entities/poi.dart
│   ├── domain/repositories/poi_repository.dart
│   ├── data/repositories/poi_repository_impl.dart
│   ├── presentation/cubit/poi_detail_cubit.dart
│   ├── presentation/pages/poi_detail_page.dart
│   └── presentation/pages/poi_reputation_page.dart
├── discover/presentation/pages/
│   └── rank_category_page.dart                 [新增]
├── tools/presentation/pages/
│   ├── fx_page.dart                            [新增]
│   ├── unit_converter_page.dart                [新增]
│   └── timezone_page.dart                      [新增]
├── emergency/                                  [新增整个 feature]
│   ├── domain/entities/emergency.dart
│   ├── domain/repositories/emergency_repository.dart
│   ├── data/repositories/emergency_repository_impl.dart
│   └── presentation/pages/emergency_page.dart
├── phrases/                                    [新增整个 feature]
│   ├── domain/entities/phrase.dart
│   ├── domain/repositories/phrases_repository.dart
│   ├── data/repositories/phrases_repository_impl.dart
│   ├── presentation/cubit/phrases_cubit.dart
│   ├── presentation/pages/phrases_index_page.dart
│   └── presentation/pages/phrases_category_page.dart
└── you/presentation/pages/
    ├── about_page.dart                         [新增]
    └── privacy_full_page.dart                  [新增]
```

### 0.3 Admin 新增文件

```
admin/src/
├── pages/
│   ├── Login/index.tsx                         [改：接后端 auth]
│   ├── Dashboard/index.tsx                     [改：路由到子页]
│   ├── PoiManagement/                          [新增]
│   │   ├── List.tsx
│   │   ├── Edit.tsx
│   │   └── Import.tsx
│   ├── PolicyManagement/                       [新增]
│   │   ├── List.tsx
│   │   └── Edit.tsx
│   ├── ChecklistManagement/                    [新增]
│   ├── DiscoverManagement/                     [新增]
│   ├── RankManagement/                         [新增]
│   ├── CorrectionReview/                       [新增]
│   ├── EmergencyManagement/                    [新增]
│   └── PhraseManagement/                       [新增]
├── components/ProtectedRoute.tsx               [改：接后端 auth]
└── services/
    ├── http.ts                                 [保持]
    └── auth.ts                                 [新增：login/logout]
```

---

## 1. 第一周：后端骨架 + DB

### Task 1: 创建 Policy Entity

**Files:**
- Create: `backend/src/modules/policy/entities/policy.entity.ts`

- [ ] **Step 1: 创建 entity 文件**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('policies')
@Index(['country', 'reason', 'category'])
export class Policy {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 8 })
  country!: string; // ISO 3166-1 alpha-2: US, GB, JP, ...

  @Column({ length: 32 })
  reason!: string; // tourism | business | family_visit | education | work | transit

  @Column({ length: 32 })
  category!: string; // visa_free | visa_required | transit | customs | consular | residence

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'text' })
  contentZh!: string;

  @Column({ type: 'text' })
  contentEn!: string;

  @Column({ length: 500, nullable: true })
  sourceUrl?: string;

  @Column({ length: 200, nullable: true })
  sourceName?: string;

  @Column({ type: 'date' })
  updatedAt!: string;

  @CreateDateColumn()
  createdAt!: Date;
}
```

- [ ] **Step 2: 编译验证**

Run: `cd backend && npm run build`
Expected: 0 error，entity 类已注册到 dist

- [ ] **Step 3: 提交**

```bash
git add backend/src/modules/policy/entities/
git commit -m "feat(backend): add Policy entity"
```

---

### Task 2: 创建 Checklist Entity

**Files:**
- Create: `backend/src/modules/checklist/entities/checklist.entity.ts`

- [ ] **Step 1: 创建 entity 文件**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

export interface ChecklistItem {
  id: string;
  titleZh: string;
  titleEn: string;
  detailZh?: string;
  detailEn?: string;
  officialUrl?: string;
  order: number;
}

@Entity('checklists')
@Index(['country', 'reason', 'city'])
export class Checklist {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 8 })
  country!: string;

  @Column({ length: 32 })
  reason!: string;

  @Column({ length: 16, default: 'SH' })
  city!: string; // SH | BJ | GZ | OTHER

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'jsonb' })
  items!: ChecklistItem[];
}
```

- [ ] **Step 2: 编译验证 + 提交**

Run: `cd backend && npm run build`
Expected: 0 error

```bash
git add backend/src/modules/checklist/entities/
git commit -m "feat(backend): add Checklist entity"
```

---

### Task 3: 创建 Poi + PoiTag + PoiReputation Entity

**Files:**
- Create: `backend/src/modules/poi/entities/poi.entity.ts`
- Create: `backend/src/modules/poi/entities/poi-tag.entity.ts`
- Create: `backend/src/modules/poi/entities/poi-reputation.entity.ts`

- [ ] **Step 1: 创建 Poi entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, Index } from 'typeorm';
import { PoiTag } from './poi-tag.entity';
import { PoiReputation } from './poi-reputation.entity';

@Entity('pois')
@Index(['city', 'category'])
export class Poi {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 200 })
  nameZh!: string;

  @Column({ length: 200 })
  nameEn!: string;

  @Column({ length: 500 })
  addressZh!: string;

  @Column({ length: 500 })
  addressEn!: string;

  @Column({ type: 'double precision' })
  lat!: number;

  @Column({ type: 'double precision' })
  lng!: number;

  @Column({ length: 32 })
  category!: string; // attraction | dining | lodging | shopping

  @Column({ length: 16, default: 'SH' })
  city!: string;

  @Column({ length: 50, nullable: true })
  contact?: string;

  @Column({ length: 200, nullable: true })
  openHours?: string;

  @Column({ type: 'text', array: true, default: [] })
  imageUrls!: string[];

  @Column({ type: 'text', nullable: true })
  descriptionZh?: string;

  @Column({ type: 'text', nullable: true })
  descriptionEn?: string;

  @OneToMany(() => PoiTag, tag => tag.poi)
  tags?: PoiTag[];

  @OneToMany(() => PoiReputation, rep => rep.poi)
  reputation?: PoiReputation;
}
```

- [ ] **Step 2: 创建 PoiTag entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Poi } from './poi.entity';

@Entity('poi_tags')
export class PoiTag {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 64 })
  tagKey!: string; // e.g. "accepts_foreign_card", "english_menu"

  @Column({ length: 16 })
  category!: 'positive' | 'warning' | 'risk';

  @Column({ length: 200 })
  labelZh!: string;

  @Column({ length: 200 })
  labelEn!: string;

  @ManyToOne(() => Poi, poi => poi.tags, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'poi_id' })
  poi!: Poi;
}
```

- [ ] **Step 3: 创建 PoiReputation entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, UpdateDateColumn } from 'typeorm';
import { Poi } from './poi.entity';

@Entity('poi_reputations')
export class PoiReputation {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => Poi, poi => poi.reputation, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'poi_id' })
  poi!: Poi;

  @Column({ type: 'real', default: 0 })
  overallScore!: number;

  @Column({ type: 'real', default: 0 })
  foreignFriendly!: number;

  @Column({ type: 'real', default: 0 })
  languageSupport!: number;

  @Column({ type: 'real', default: 0 })
  paymentEase!: number;

  @Column({ type: 'real', default: 0 })
  authenticity!: number;

  @Column({ type: 'real', default: 0 })
  value!: number;

  @Column({ default: false })
  officialVerified!: boolean;

  @Column({ type: 'text', array: true, default: [] })
  experienceTipsZh!: string[];

  @Column({ type: 'text', array: true, default: [] })
  experienceTipsEn!: string[];

  @UpdateDateColumn()
  updatedAt!: Date;
}
```

- [ ] **Step 4: 编译 + 提交**

Run: `cd backend && npm run build`
Expected: 0 error

```bash
git add backend/src/modules/poi/entities/
git commit -m "feat(backend): add Poi/PoiTag/PoiReputation entities"
```

---

### Task 4: 创建 DiscoverCard + Rank Entity

**Files:**
- Create: `backend/src/modules/discover/entities/discover-card.entity.ts`
- Create: `backend/src/modules/discover/entities/rank.entity.ts`

- [ ] **Step 1: DiscoverCard entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('discover_cards')
@Index(['category', 'order'])
export class DiscoverCard {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 32 })
  category!: 'curated' | 'authentic' | 'heads_up';

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'text' })
  summaryZh!: string;

  @Column({ type: 'text' })
  summaryEn!: string;

  @Column({ length: 500 })
  imageUrl!: string;

  @Column({ type: 'text', array: true, default: [] })
  relatedPoiIds!: string[];

  @Column({ type: 'int', default: 0 })
  order!: number;
}
```

- [ ] **Step 2: Rank entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, Index, UpdateDateColumn } from 'typeorm';

export interface RankItem {
  poiId: string;
  reasonZh: string;
  reasonEn: string;
  order: number;
}

@Entity('ranks')
@Index(['category', 'order'])
export class Rank {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 32 })
  category!: 'dining' | 'shopping' | 'attraction' | 'family' | 'couple' | 'business' | 'solo' | 'warning';

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'jsonb' })
  items!: RankItem[];

  @Column({ type: 'int', default: 0 })
  order!: number;

  @UpdateDateColumn()
  updatedAt!: Date;
}
```

- [ ] **Step 3: 编译 + 提交**

```bash
git add backend/src/modules/discover/entities/
git commit -m "feat(backend): add DiscoverCard and Rank entities"
```

---

### Task 5: 创建 EmergencyContact + Phrase + FxRate Entity

**Files:**
- Create: `backend/src/modules/tools/entities/emergency-contact.entity.ts`
- Create: `backend/src/modules/tools/entities/phrase.entity.ts`
- Create: `backend/src/modules/tools/entities/fx-rate.entity.ts`

- [ ] **Step 1: EmergencyContact entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('emergency_contacts')
@Index(['country', 'type'])
export class EmergencyContact {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 8, default: '*' })
  country!: string; // * 通用，否则 ISO

  @Column({ length: 16 })
  type!: 'police' | 'medical' | 'fire' | 'consulate' | 'tourist_hotline';

  @Column({ length: 200 })
  nameZh!: string;

  @Column({ length: 200 })
  nameEn!: string;

  @Column({ length: 50 })
  phone!: string;

  @Column({ length: 500, nullable: true })
  addressZh?: string;

  @Column({ length: 500, nullable: true })
  addressEn?: string;
}
```

- [ ] **Step 2: Phrase entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('phrases')
@Index(['category', 'order'])
export class Phrase {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 32 })
  category!: 'customs' | 'taxi' | 'dining' | 'medical' | 'emergency' | 'shopping';

  @Column({ type: 'text' })
  en!: string;

  @Column({ type: 'text' })
  zh!: string;

  @Column({ type: 'text' })
  pinyin!: string;

  @Column({ type: 'int', default: 0 })
  order!: number;
}
```

- [ ] **Step 3: FxRate entity**

```typescript
import { Entity, PrimaryColumn, Column, UpdateDateColumn } from 'typeorm';

@Entity('fx_rates')
export class FxRate {
  @PrimaryColumn({ length: 8 })
  fromCurrency!: string; // USD

  @PrimaryColumn({ length: 8 })
  toCurrency!: string; // CNY

  @Column({ type: 'real' })
  rate!: number;

  @UpdateDateColumn()
  updatedAt!: Date;
}
```

- [ ] **Step 4: 编译 + 提交**

```bash
git add backend/src/modules/tools/entities/
git commit -m "feat(backend): add EmergencyContact/Phrase/FxRate entities"
```

---

### Task 6: 创建 Correction + User Entity

**Files:**
- Create: `backend/src/modules/correction/entities/correction.entity.ts`
- Create: `backend/src/modules/user/entities/user.entity.ts`

- [ ] **Step 1: Correction entity**

```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('corrections')
@Index(['status'])
export class Correction {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 64 })
  anonymousId!: string;

  @Column({ length: 32 })
  type!: 'content_error' | 'policy' | 'poi' | 'phrase' | 'other';

  @Column({ length: 200, nullable: true })
  targetId?: string;

  @Column({ type: 'text' })
  message!: string;

  @Column({ length: 200, nullable: true })
  contactEmail?: string;

  @Column({ length: 16, default: 'queued' })
  status!: 'queued' | 'reviewing' | 'resolved' | 'rejected';

  @Column({ length: 64, nullable: true })
  reviewerId?: string;

  @Column({ type: 'text', nullable: true })
  reviewNote?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
```

- [ ] **Step 2: User entity（匿名用户）**

```typescript
import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryColumn({ length: 64 })
  anonymousId!: string;

  @Column({ length: 16, default: 'en' })
  locale!: string;

  @Column({ length: 16, default: 'system' })
  theme!: string;

  @Column({ length: 16, default: 'metric' })
  unit!: string;

  @Column({ length: 8, nullable: true })
  country?: string;

  @Column({ length: 32, nullable: true })
  entryReason?: string;

  @Column({ length: 16, nullable: true })
  entryCity?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
```

- [ ] **Step 3: 编译 + 提交**

```bash
git add backend/src/modules/correction/entities/ backend/src/modules/user/entities/
git commit -m "feat(backend): add Correction and User entities"
```

---

### Task 7: 注册所有 Entity 到 TypeORM

**Files:**
- Modify: `backend/src/config/typeorm.config.ts`

- [ ] **Step 1: 改 typeorm 配置**

```typescript
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { Policy } from '../modules/policy/entities/policy.entity';
import { Checklist } from '../modules/checklist/entities/checklist.entity';
import { Poi } from '../modules/poi/entities/poi.entity';
import { PoiTag } from '../modules/poi/entities/poi-tag.entity';
import { PoiReputation } from '../modules/poi/entities/poi-reputation.entity';
import { DiscoverCard } from '../modules/discover/entities/discover-card.entity';
import { Rank } from '../modules/discover/entities/rank.entity';
import { EmergencyContact } from '../modules/tools/entities/emergency-contact.entity';
import { Phrase } from '../modules/tools/entities/phrase.entity';
import { FxRate } from '../modules/tools/entities/fx-rate.entity';
import { Correction } from '../modules/correction/entities/correction.entity';
import { User } from '../modules/user/entities/user.entity';

export const buildTypeOrmConfig = (): TypeOrmModuleOptions => ({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  username: process.env.DB_USER || 'sightour',
  password: process.env.DB_PASSWORD || 'sightour',
  database: process.env.DB_NAME || 'sightour',
  entities: [
    Policy, Checklist, Poi, PoiTag, PoiReputation,
    DiscoverCard, Rank,
    EmergencyContact, Phrase, FxRate,
    Correction, User,
  ],
  synchronize: process.env.NODE_ENV !== 'production',
  logging: process.env.NODE_ENV === 'development' ? ['error', 'warn'] : false,
});
```

- [ ] **Step 2: 编译 + 提交**

Run: `cd backend && npm run build`
Expected: 0 error

```bash
git add backend/src/config/typeorm.config.ts
git commit -m "feat(backend): register all 12 entities in TypeORM config"
```

---

### Task 8: 启动 docker compose 验证 DB 连接

**Files:**
- Modify: `deploy/docker-compose.yml`（确认已就位）

- [ ] **Step 1: 启动数据库**

```bash
cd deploy
docker compose up -d postgres redis minio
docker compose ps
```
Expected: 3 个容器 healthy

- [ ] **Step 2: 验证后端能连 DB**

```bash
cd backend
npm run start:dev
```
Expected: Nest 启动日志中 TypeORM 显示 12 entities registered，DB 连接成功

- [ ] **Step 3: 验证表已建**

```bash
docker exec -it deploy-postgres-1 psql -U sightour -d sightour -c "\dt"
```
Expected: 12 张表：policies, checklists, pois, poi_tags, poi_reputations, discover_cards, ranks, emergency_contacts, phrases, fx_rates, corrections, users

---

### Task 9-16: 生成 PGC seeds JSON（按 Task 顺序）

> 这些 seed 文件从 `app/lib/core/network/mock_data.dart` 中提取并转译为 JSON。脚本化生成。

**Files:**
- Create: `backend/seeds/policies.json`（10 国 × 5 目的 × 4 类目 = 200 条）
- Create: `backend/seeds/checklists.json`（10 国 × 5 目的 × 3 城 = 150 条）
- Create: `backend/seeds/pois.json`（SH 15 / BJ 8 / GZ 7 = 30 条）
- Create: `backend/seeds/reputations.json`（30 条，对应 POI）
- Create: `backend/seeds/tags.json`（20 条字典）
- Create: `backend/seeds/discover.json`（3 段 × 4 卡 = 12 张）
- Create: `backend/seeds/ranks.json`（8 类榜单：dining/shopping/attraction/family/couple/business/solo/warning）
- Create: `backend/seeds/phrases.json`（5 类 × 15 条 = 75 条）
- Create: `backend/seeds/emergency.json`（10 国领事馆 + 4 个通用号码）
- Create: `backend/seeds/fx-rates.json`（7 货币对 × CNY = 7 条）

- [ ] **Step 9.1: 编写一个一次性转换脚本**

```bash
# 用 Node 脚本从 app/lib/core/network/mock_data.dart 提取
node scripts/extract-mock-to-seeds.js
```

- [ ] **Step 9.2: 验证生成的 JSON**

```bash
cat backend/seeds/policies.json | head -50
```
Expected: 含至少 1 条 US tourism visa_free 记录

- [ ] **Step 9.3: 提交**

```bash
git add backend/seeds/
git commit -m "content(backend): generate PGC seeds from mock data (10 国 × 5 目的 = 250 条政策/清单)"
```

---

### Task 17: 编写 idempotent seed 脚本

**Files:**
- Create: `backend/src/seeds/seed.service.ts`
- Create: `backend/src/seeds/seed.module.ts`
- Modify: `backend/src/app.module.ts`

- [ ] **Step 1: SeedService**

```typescript
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as fs from 'fs';
import * as path from 'path';

import { Policy } from '../modules/policy/entities/policy.entity';
import { Checklist } from '../modules/checklist/entities/checklist.entity';
import { Poi } from '../modules/poi/entities/poi.entity';
import { PoiTag } from '../modules/poi/entities/poi-tag.entity';
import { PoiReputation } from '../modules/poi/entities/poi-reputation.entity';
import { DiscoverCard } from '../modules/discover/entities/discover-card.entity';
import { Rank } from '../modules/discover/entities/rank.entity';
import { EmergencyContact } from '../modules/tools/entities/emergency-contact.entity';
import { Phrase } from '../modules/tools/entities/phrase.entity';
import { FxRate } from '../modules/tools/entities/fx-rate.entity';

@Injectable()
export class SeedService {
  private readonly logger = new Logger(SeedService.name);

  constructor(
    @InjectRepository(Policy) private policyRepo: Repository<Policy>,
    @InjectRepository(Checklist) private checklistRepo: Repository<Checklist>,
    @InjectRepository(Poi) private poiRepo: Repository<Poi>,
    @InjectRepository(PoiTag) private poiTagRepo: Repository<PoiTag>,
    @InjectRepository(PoiReputation) private poiRepRepo: Repository<PoiReputation>,
    @InjectRepository(DiscoverCard) private discoverRepo: Repository<DiscoverCard>,
    @InjectRepository(Rank) private rankRepo: Repository<Rank>,
    @InjectRepository(EmergencyContact) private emergencyRepo: Repository<EmergencyContact>,
    @InjectRepository(Phrase) private phraseRepo: Repository<Phrase>,
    @InjectRepository(FxRate) private fxRepo: Repository<FxRate>,
  ) {}

  async seedAll() {
    const seedsDir = path.join(__dirname, '..', '..', 'seeds');
    await this.upsert(this.policyRepo, 'policies', path.join(seedsDir, 'policies.json'));
    await this.upsert(this.checklistRepo, 'checklists', path.join(seedsDir, 'checklists.json'));
    await this.upsert(this.poiRepo, 'pois', path.join(seedsDir, 'pois.json'));
    await this.upsert(this.poiRepRepo, 'reputations', path.join(seedsDir, 'reputations.json'));
    await this.upsert(this.poiTagRepo, 'tags', path.join(seedsDir, 'tags.json'));
    await this.upsert(this.discoverRepo, 'discover', path.join(seedsDir, 'discover.json'));
    await this.upsert(this.rankRepo, 'ranks', path.join(seedsDir, 'ranks.json'));
    await this.upsert(this.phraseRepo, 'phrases', path.join(seedsDir, 'phrases.json'));
    await this.upsert(this.emergencyRepo, 'emergency', path.join(seedsDir, 'emergency.json'));
    await this.upsert(this.fxRepo, 'fx-rates', path.join(seedsDir, 'fx-rates.json'));
    this.logger.log('✅ PGC seed complete');
  }

  private async upsert<T>(repo: Repository<T>, key: string, filePath: string) {
    if (!fs.existsSync(filePath)) {
      this.logger.warn(`Seed file not found: ${filePath}`);
      return;
    }
    const data = JSON.parse(fs.readFileSync(filePath, 'utf-8')) as T[];
    if (data.length === 0) return;
    // 用 save() 实现 upsert：先清空再插入（开发期用，生产用 batch upsert）
    await repo.clear();
    await repo.save(data);
    this.logger.log(`✓ ${key}: ${data.length} records`);
  }
}
```

- [ ] **Step 2: SeedModule**

```typescript
import { Module, OnApplicationBootstrap } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SeedService } from './seed.service';
import { Policy } from '../modules/policy/entities/policy.entity';
import { Checklist } from '../modules/checklist/entities/checklist.entity';
import { Poi } from '../modules/poi/entities/poi.entity';
import { PoiTag } from '../modules/poi/entities/poi-tag.entity';
import { PoiReputation } from '../modules/poi/entities/poi-reputation.entity';
import { DiscoverCard } from '../modules/discover/entities/discover-card.entity';
import { Rank } from '../modules/discover/entities/rank.entity';
import { EmergencyContact } from '../modules/tools/entities/emergency-contact.entity';
import { Phrase } from '../modules/tools/entities/phrase.entity';
import { FxRate } from '../modules/tools/entities/fx-rate.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Policy, Checklist, Poi, PoiTag, PoiReputation,
      DiscoverCard, Rank,
      EmergencyContact, Phrase, FxRate,
    ]),
  ],
  providers: [SeedService],
  exports: [SeedService],
})
export class SeedModule implements OnApplicationBootstrap {
  constructor(private seedService: SeedService) {}
  async onApplicationBootstrap() {
    if (process.env.SEED_ON_BOOT !== 'false') {
      await this.seedService.seedAll();
    }
  }
}
```

- [ ] **Step 3: AppModule 引入**

```typescript
// backend/src/app.module.ts
import { SeedModule } from './seeds/seed.module';

@Module({
  imports: [
    // ... 已有 modules
    SeedModule,
  ],
})
export class AppModule {}
```

- [ ] **Step 4: 重启后端验证**

Run: `cd backend && npm run start:dev`
Expected: 启动日志中 `SeedService` 打印 `✓ policies: 200 records` 等 10 行

- [ ] **Step 5: 提交**

```bash
git add backend/src/seeds/ backend/src/app.module.ts
git commit -m "feat(backend): idempotent PGC seed on boot"
```

---

### Task 18: 改 PolicyService 接 Repository

**Files:**
- Modify: `backend/src/modules/policy/policy.service.ts`
- Modify: `backend/src/modules/policy/policy.module.ts`

- [ ] **Step 1: 改 PolicyService**

```typescript
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Policy } from './entities/policy.entity';

@Injectable()
export class PolicyService {
  constructor(
    @InjectRepository(Policy)
    private readonly policyRepo: Repository<Policy>,
  ) {}

  async list(query: { country?: string; reason?: string; city?: string; category?: string }) {
    const qb = this.policyRepo.createQueryBuilder('p');
    if (query.country) qb.andWhere('p.country = :country', { country: query.country });
    if (query.reason) qb.andWhere('p.reason = :reason', { reason: query.reason });
    if (query.category) qb.andWhere('p.category = :category', { category: query.category });
    qb.orderBy('p.category', 'ASC').addOrderBy('p.updatedAt', 'DESC');
    const data = await qb.getMany();
    return { data };
  }

  async findById(id: string) {
    const policy = await this.policyRepo.findOne({ where: { id } });
    if (!policy) throw new NotFoundException(`Policy ${id} not found`);
    return policy;
  }
}
```

- [ ] **Step 2: 改 PolicyModule**

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PolicyController } from './policy.controller';
import { PolicyService } from './policy.service';
import { Policy } from './entities/policy.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Policy])],
  controllers: [PolicyController],
  providers: [PolicyService],
})
export class PolicyModule {}
```

- [ ] **Step 3: 启动验证**

```bash
curl "http://localhost:3000/api/v1/policies?country=US&reason=tourism" | jq '.data | length'
```
Expected: 4

- [ ] **Step 4: 提交**

```bash
git add backend/src/modules/policy/
git commit -m "feat(backend): PolicyService reads from PG with country/reason filters"
```

---

### Task 19: 改 PoiService 接 Repository（带 search 过滤）

**Files:**
- Modify: `backend/src/modules/poi/poi.service.ts`

- [ ] **Step 1: 改 service**

```typescript
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Poi } from './entities/poi.entity';
import { PoiReputation } from './entities/poi-reputation.entity';
import { PoiTag } from './entities/poi-tag.entity';

@Injectable()
export class PoiService {
  constructor(
    @InjectRepository(Poi) private poiRepo: Repository<Poi>,
    @InjectRepository(PoiReputation) private repRepo: Repository<PoiReputation>,
    @InjectRepository(PoiTag) private tagRepo: Repository<PoiTag>,
  ) {}

  async search(q: { q?: string; category?: string; city?: string }) {
    const qb = this.poiRepo.createQueryBuilder('p');
    if (q.city) qb.andWhere('p.city = :city', { city: q.city });
    if (q.category) qb.andWhere('p.category = :category', { category: q.category });
    if (q.q) {
      qb.andWhere('(p.nameZh ILIKE :kw OR p.nameEn ILIKE :kw OR p.addressZh ILIKE :kw OR p.addressEn ILIKE :kw)', {
        kw: `%${q.q}%`,
      });
    }
    qb.orderBy('p.nameEn', 'ASC').limit(50);
    return { data: await qb.getMany() };
  }

  async findById(id: string) {
    const poi = await this.poiRepo.findOne({
      where: { id },
      relations: ['tags', 'reputation'],
    });
    if (!poi) throw new NotFoundException(`POI ${id} not found`);
    return poi;
  }

  async getReputation(poiId: string) {
    const rep = await this.repRepo.findOne({ where: { poi: { id: poiId } } });
    if (!rep) throw new NotFoundException(`Reputation for ${poiId} not found`);
    return rep;
  }
}
```

- [ ] **Step 2: 改 Controller 添加新 endpoint**

```typescript
// policy.controller.ts → poi.controller.ts
import { Controller, Get, Param, Query } from '@nestjs/common';
import { PoiService } from './poi.service';

@Controller('pois')
export class PoiController {
  constructor(private readonly poiService: PoiService) {}

  @Get('search')
  search(
    @Query('q') q?: string,
    @Query('category') category?: string,
    @Query('city') city?: string,
  ) {
    return this.poiService.search({ q, category, city });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.poiService.findById(id);
  }

  @Get(':id/reputation')
  reputation(@Param('id') id: string) {
    return this.poiService.getReputation(id);
  }
}
```

- [ ] **Step 3: 改 PoiModule**

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PoiController } from './poi.controller';
import { PoiService } from './poi.service';
import { Poi } from './entities/poi.entity';
import { PoiTag } from './entities/poi-tag.entity';
import { PoiReputation } from './entities/poi-reputation.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Poi, PoiTag, PoiReputation])],
  controllers: [PoiController],
  providers: [PoiService],
})
export class PoiModule {}
```

- [ ] **Step 4: 启动验证**

```bash
curl "http://localhost:3000/api/v1/pois/search?city=SH&category=attraction" | jq '.data | length'
```
Expected: 5

- [ ] **Step 5: 提交**

```bash
git add backend/src/modules/poi/
git commit -m "feat(backend): PoiService reads from PG with search/filter"
```

---

### Task 20-26: 剩余 Service 改造

| Task | 文件 | 关键改动 |
|---|---|---|
| 20 | `checklist.service.ts` | 注入 `Checklist` repo；list 用 country/reason/city 过滤；`PATCH /checklists/:id/toggle` 接受 anonymousId 写勾选状态（用 Redis 持久化） |
| 21 | `reputation.service.ts` | 注入 `PoiReputation` repo；list 按 poiId 过滤 |
| 22 | `correction.service.ts` | 注入 `Correction` repo；新增 `POST /corrections`（任意 anonId 可写，状态默认 queued）；新增 `PATCH /corrections/:id`（admin 更新状态）|
| 23 | 新增 `discover.module.ts` | 注入 `DiscoverCard` + `Rank` repo；`GET /discover/curated\|authentic\|heads-up`；`GET /ranks/:category`；`GET /ranks/:category/:rankId` |
| 24 | 新增 `tools.module.ts` | 注入 3 个 entity；`GET /tools/fx-rates?from=&to=`；`GET /tools/emergency`；`GET /tools/phrases?category=`；`GET /tools/phrases/:category` |
| 25 | `user.service.ts` | 注入 `User` repo；`POST /users/anon` 创建匿名用户；`PATCH /users/anon/:id` 更新偏好 |
| 26 | `user.controller.ts` + `anonymous-id.interceptor.ts` | 实现 `X-Anonymous-Id` header 自动同步到 User 表（用 Redis 缓存 + 异步落库）|

**每个任务遵循同样模式**：
1. 改 service 注 Repository
2. 改 controller 添加 endpoint
3. 启动 + curl 验证
4. 提交：`git commit -m "feat(backend): <Service>Service reads from PG"`

---

## 2. 第二周：Admin 后台

### Task 27: Admin JWT 鉴权

**Files:**
- Modify: `backend/src/modules/user/` (新增 auth sub-module)
- Create: `backend/src/modules/auth/auth.service.ts`
- Create: `backend/src/modules/auth/auth.controller.ts`
- Create: `backend/src/modules/auth/auth.module.ts`
- Create: `backend/src/modules/auth/entities/admin.entity.ts`
- Create: `backend/src/common/guards/admin-jwt.guard.ts`

- [ ] **Step 1: Admin entity**

```typescript
import { Entity, PrimaryColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('admins')
export class Admin {
  @PrimaryColumn({ length: 64 })
  id!: string;

  @Column({ length: 200, unique: true })
  username!: string;

  @Column({ length: 200 })
  passwordHash!: string;

  @Column({ length: 32, default: 'editor' })
  role!: 'editor' | 'reviewer' | 'admin';

  @CreateDateColumn()
  createdAt!: Date;
}
```

- [ ] **Step 2: AuthService**

```typescript
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { Admin } from './entities/admin.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Admin) private adminRepo: Repository<Admin>,
    private jwtService: JwtService,
  ) {}

  async login(username: string, password: string) {
    const admin = await this.adminRepo.findOne({ where: { username } });
    if (!admin) throw new UnauthorizedException('Invalid credentials');
    const valid = await bcrypt.compare(password, admin.passwordHash);
    if (!valid) throw new UnauthorizedException('Invalid credentials');
    const token = this.jwtService.sign({ sub: admin.id, role: admin.role });
    return { token, admin: { id: admin.id, username: admin.username, role: admin.role } };
  }
}
```

- [ ] **Step 3: AuthController**

```typescript
import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  async login(@Body() body: { username: string; password: string }) {
    return this.authService.login(body.username, body.password);
  }
}
```

- [ ] **Step 4: Guard**

```typescript
import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AdminJwtGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest();
    const auth = req.headers.authorization;
    if (!auth || !auth.startsWith('Bearer ')) {
      throw new UnauthorizedException('Missing Bearer token');
    }
    const token = auth.substring(7);
    try {
      const payload = this.jwtService.verify(token);
      req.user = payload;
      return true;
    } catch {
      throw new UnauthorizedException('Invalid token');
    }
  }
}
```

- [ ] **Step 5: 启动后端 + curl 验证**

```bash
# 创建种子 admin
docker exec -it deploy-postgres-1 psql -U sightour -d sightour -c \
  "INSERT INTO admins (id, username, \"passwordHash\", role) VALUES ('admin-1', 'admin@sightour.com', '\$2b\$10\$hash...', 'admin');"
# 或用 seed 文件
curl -X POST http://localhost:3000/api/v1/auth/login -H "Content-Type: application/json" -d '{"username":"admin@sightour.com","password":"changeme"}'
```
Expected: `{ token: "...", admin: {...} }`

- [ ] **Step 6: 提交**

```bash
git add backend/src/modules/auth/ backend/src/common/guards/admin-jwt.guard.ts
git commit -m "feat(backend): admin JWT auth with bcrypt + guard"
```

---

### Task 28-33: Admin 5 大管理页

| Task | 页面 | API |
|---|---|---|
| 28 | Login (接真后端) | `POST /auth/login` |
| 29 | POI List + Edit | `GET /admin/pois` + `POST/PUT /admin/pois/:id` |
| 30 | POI Batch Import (上传 JSON) | `POST /admin/pois/import` |
| 31 | POI Tag Dictionary | `GET/POST/PUT /admin/tags` |
| 32 | Policy List + Edit | `GET/POST/PUT /admin/policies` |
| 33 | Checklist List + Edit | `GET/POST/PUT /admin/checklists` |

**模板（每个页面一致）**：
- `List.tsx` — `ProTable`，列：ID/名称/分类/更新时间/操作
- `Edit.tsx` — `DrawerForm`，字段 form
- 接入 `http.ts` axios 实例，token 拦截器已就位
- 提交：`git commit -m "feat(admin): <page> CRUD"`

---

## 3. 第三周：Flutter 详情页 + 联通

### Task 34: 关闭 MockInterceptor 接入真后端

**Files:**
- Modify: `app/lib/core/di/injection.config.dart`

- [ ] **Step 1: 改 DI**

```dart
// 在 mocks toggle 之前加 useMock 配置
// 推荐通过 build flavor 控制：
// flutter build apk --dart-define=USE_MOCK=false
// flutter run --dart-define=USE_MOCK=false
```

- [ ] **Step 2: 修改 MockInterceptor 注册逻辑**

```dart
@InjectableInit(...)
Future<void> configureDependencies() async => getIt.init(environment: Environment.prod);
// 或用：if (kDebugMode && const bool.fromEnvironment('USE_MOCK', defaultValue: true)) registerMock();
```

- [ ] **Step 3: 真机测试**

Run: `flutter run --dart-define=USE_MOCK=false --dart-define=API_BASE=http://10.0.2.2:3000/api/v1`
Expected: Prepare 页面真实显示后端数据（不再是 mock_data.dart）

- [ ] **Step 4: 提交**

```bash
git add app/lib/core/di/
git commit -m "feat(app): toggle real backend via USE_MOCK flag"
```

---

### Task 35-42: Flutter 详情页

| Task | 页面 | Cubit | 复用资源 |
|---|---|---|---|
| 35 | POI 详情页 | `PoiDetailCubit` | 复用 `IllustrationBanner` + `AppSegmentedTab` + 暖色卡 |
| 36 | POI 口碑页 | `PoiReputationCubit` | 5 维度进度条 + 体验提示列表 |
| 37 | Policy 详情页 | `PolicyDetailCubit` | 复用 Prepare 卡片样式 + 渐变背景 |
| 38 | Checklist 独立页 | `ChecklistCubit` | 复用 `CircularProgressRing` + 勾选行 |
| 39 | Discover 榜单页 | `RankCategoryCubit` | 复用 Discover 渐变卡 |
| 40 | FX / 单位 / 时区工具页 | 复用 `FxConverterCubit` | 渐变输入框 + 实时换算 |
| 41 | Emergency + Phrases 页 | 新增 | 复用顶部 IllustrationBanner + ListView |
| 42 | About + Privacy 全文 | 静态 | 富文本 Widget |

**每个详情页模板**：
- 富 UI + 动画（沿用 Prepare 标准）
- BlocProvider → Cubit → 调 Repository → HTTP
- 错误态 / 加载态 / 空态 三态齐备
- 提交：`git commit -m "feat(app): <Page> page"`

---

## 4. 第四周：测试 + 收尾

### Task 43: 后端单元测试

**Files:**
- Create: `backend/src/modules/policy/policy.service.spec.ts`（同模块其他 4 个 service 各一份）

- [ ] **Step 1: PolicyService spec**

```typescript
import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { PolicyService } from './policy.service';
import { Policy } from './entities/policy.entity';

describe('PolicyService', () => {
  let service: PolicyService;
  const mockRepo = {
    createQueryBuilder: jest.fn(() => ({
      andWhere: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      addOrderBy: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue([{ id: '1', country: 'US' }]),
    })),
    findOne: jest.fn(),
  };

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        PolicyService,
        { provide: getRepositoryToken(Policy), useValue: mockRepo },
      ],
    }).compile();
    service = module.get(PolicyService);
  });

  it('list returns data', async () => {
    const result = await service.list({ country: 'US' });
    expect(result.data).toHaveLength(1);
  });
});
```

- [ ] **Step 2: 跑测试**

Run: `cd backend && npm test`
Expected: 5/5 spec files pass

- [ ] **Step 3: 提交**

```bash
git add backend/src/modules/
git commit -m "test(backend): unit tests for 5 services"
```

---

### Task 44: 前端 e2e 测试

**Files:**
- Create: `app/integration_test/onboarding_to_feedback_test.dart`

- [ ] **Step 1: 写 e2e**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sightour/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding → policy → feedback', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    // 走完 onboarding
    // 验证 Prepare 页面有数据
    // 点 checklist item 勾选
    // 提交 feedback
    // 验证回退到 /you
  });
}
```

- [ ] **Step 2: 跑测试**

Run: `cd app && flutter test integration_test/`
Expected: pass

- [ ] **Step 3: 提交**

```bash
git add app/integration_test/
git commit -m "test(app): e2e test for onboarding→policy→feedback"
```

---

### Task 45: 修 backend/test/app.e2e-spec.ts

**Files:**
- Modify: `backend/test/app.e2e-spec.ts`

- [ ] **Step 1: 改为健康检查测试**

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Health (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api/v1');
    await app.init();
  });

  it('/health (GET) returns 200', () => {
    return request(app.getHttpServer()).get('/health').expect(200);
  });
});
```

- [ ] **Step 2: 跑测试**

Run: `cd backend && npm run test:e2e`
Expected: pass

- [ ] **Step 3: 提交**

```bash
git add backend/test/
git commit -m "test(backend): e2e test for /health"
```

---

### Task 46: 启用 admin-ci 严格 lint

**Files:**
- Modify: `.github/workflows/admin-ci.yml`

- [ ] **Step 1: 移除 `|| true`**

```yaml
- name: Lint
  run: npm run lint
```

- [ ] **Step 2: 提交**

```bash
git add .github/workflows/admin-ci.yml
git commit -m "ci: enable strict lint in admin-ci"
```

---

### Task 47: 最终验证清单

- [ ] `cd backend && npm run build && npm test && npm run test:e2e` 全绿
- [ ] `cd admin && npm run build && npm run lint` 全绿
- [ ] `cd app && flutter analyze && flutter test` 全绿
- [ ] `cd app && flutter test integration_test/` 全绿
- [ ] 真机跑通 onboarding → 政策 → 清单 → POI 详情 → 反馈 完整链路
- [ ] Admin 登录 → 编辑 POI → 前端实时看到更新

---

## 5. 总结

| 周 | 主题 | 完成任务数 | 关键产出 |
|---|---|---|---|
| W1 | 后端骨架 + DB | Task 1-26 | 12 Entity + 10 seeds + 6 真后端 service + POST corrections |
| W2 | Admin 后台 | Task 27-33 | JWT auth + 5 大 CRUD 模块 |
| W3 | 前端详情页 | Task 34-42 | 9 个新页面 + 切真后端 |
| W4 | 测试 + 收尾 | Task 43-47 | 单测 + e2e + CI 全绿 |

**总任务数**：47 个 Task（每个 3-8 步）

**完成后状态**：
- 7 大模块 P0 功能 100% 端到端跑通
- 10 国 × 5 目的 × 3 城内容覆盖
- 30+ POI + 评分 + 标签
- 75 条短语 + 紧急联系 + 7 货币对
- Admin 5 大 CRUD 全部可用
- CI 三套 pipeline 全绿

**后续阶段（v1.1+）**：高德 SDK、离线包、第三方口碑引用、双人复核、公共出行、暗色模式完整适配。

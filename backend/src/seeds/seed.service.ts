import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, ObjectLiteral } from 'typeorm';
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

  private async upsert<T extends ObjectLiteral>(repo: Repository<T>, key: string, filePath: string) {
    if (!fs.existsSync(filePath)) {
      this.logger.warn(`Seed file not found: ${filePath}`);
      return;
    }
    const data = JSON.parse(fs.readFileSync(filePath, 'utf-8')) as T[];
    if (data.length === 0) return;
    // 用 save() 实现 upsert：先清空再插入（开发期用，生产用 batch upsert）
    // 用 TRUNCATE ... CASCADE 避免被外键约束的子表阻塞
    await repo.query(`TRUNCATE TABLE "${repo.metadata.tableName}" CASCADE`);
    await repo.save(data);
    this.logger.log(`✓ ${key}: ${data.length} records`);
  }
}

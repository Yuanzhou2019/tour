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
import { AdminUser } from '../modules/auth/entities/admin-user.entity';
import { AuthService } from '../modules/auth/auth.service';

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
    @InjectRepository(AdminUser) private adminRepo: Repository<AdminUser>,
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
    await this.upsert(this.fxRepo, 'fx-rates', path.join(seedsDir, 'fx-rates.json'), ['fromCurrency', 'toCurrency']);
    await this.seedAdminUser();
    this.logger.log('✅ PGC seed complete');
  }

  private async upsert<T extends ObjectLiteral>(repo: Repository<T>, key: string, filePath: string, conflictPaths?: string[]) {
    if (!fs.existsSync(filePath)) {
      this.logger.warn(`Seed file not found: ${filePath}`);
      return;
    }
    const data = JSON.parse(fs.readFileSync(filePath, 'utf-8')) as T[];
    if (data.length === 0) return;
    const processed = this.preprocessData(data, repo);
    await repo.upsert(processed as any, conflictPaths ?? ['id']);
    this.logger.log(`✓ ${key}: ${processed.length} records`);
  }

  /**
   * Transform flat FK fields (e.g. "poiId": "uuid") into the nested form
   * expected by TypeORM relations (e.g. "poi": { "id": "uuid" }). Any key
   * ending with "Id" (other than "id" itself) is treated as a potential
   * relation name; we only convert it if the seed JSON does not already
   * provide the nested form, and the relation column is a string/number.
   */
  private preprocessData<T extends ObjectLiteral>(data: any[], repo: Repository<T>): T[] {
    return data.map((record) => {
      if (!record || typeof record !== 'object') return record;
      const processed: any = { ...record };
      Object.keys(processed).forEach((key) => {
        if (key.endsWith('Id') && key !== 'id' && processed[key]) {
          const relationName = key.slice(0, -2); // 'poiId' -> 'poi'
          // Skip if the nested form is already present
          if (
            processed[relationName] === undefined ||
            processed[relationName] === null
          ) {
            processed[relationName] = { id: processed[key] };
          }
        }
      });
      return processed as T;
    });
  }

  /** 种子管理员账号（仅当 admin_users 表为空时插入） */
  private async seedAdminUser() {
    const count = await this.adminRepo.count();
    if (count > 0) {
      this.logger.log('✓ admin_users: already seeded, skipping');
      return;
    }
    const admin = this.adminRepo.create({
      username: 'admin',
      passwordHash: AuthService.hashPassword('sightour2026'),
      role: 'admin',
    });
    await this.adminRepo.save(admin);
    this.logger.log('✓ admin_users: 1 record (username=admin, password=sightour2026)');
  }
}

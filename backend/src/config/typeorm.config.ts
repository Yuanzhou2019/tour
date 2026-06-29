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
import { AdminUser } from '../modules/auth/entities/admin-user.entity';

export const buildTypeOrmConfig = (): TypeOrmModuleOptions => ({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  username: process.env.DB_USER || 'sightour',
  password: process.env.DB_PASSWORD || 'sightour',
  database: process.env.DB_NAME || 'sightour',
  entities: [
    Policy,
    Checklist,
    Poi,
    PoiTag,
    PoiReputation,
    DiscoverCard,
    Rank,
    EmergencyContact,
    Phrase,
    FxRate,
    Correction,
    User,
    AdminUser,
  ],
  synchronize: process.env.NODE_ENV !== 'production',
  logging: process.env.NODE_ENV === 'development' ? ['error', 'warn'] : false,
});

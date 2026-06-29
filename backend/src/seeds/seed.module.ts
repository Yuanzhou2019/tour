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

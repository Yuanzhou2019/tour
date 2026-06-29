import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DiscoverCard } from './entities/discover-card.entity';
import { Rank } from './entities/rank.entity';
import { DiscoverService } from './discover.service';
import { DiscoverController, RankController } from './discover.controller';

@Module({
  imports: [TypeOrmModule.forFeature([DiscoverCard, Rank])],
  controllers: [DiscoverController, RankController],
  providers: [DiscoverService],
})
export class DiscoverModule {}
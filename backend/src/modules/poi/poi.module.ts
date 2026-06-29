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
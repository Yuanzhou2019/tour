import { Module } from '@nestjs/common';
import { ContentPackController } from './content-pack.controller';
import { ContentPackService } from './content-pack.service';

@Module({
  controllers: [ContentPackController],
  providers: [ContentPackService],
})
export class ContentPackModule {}

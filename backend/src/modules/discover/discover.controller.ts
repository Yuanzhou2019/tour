import { Controller, Get, Param } from '@nestjs/common';
import { DiscoverService } from './discover.service';

@Controller('discover')
export class DiscoverController {
  constructor(private readonly discoverService: DiscoverService) {}

  @Get('curated')
  curated() {
    return this.discoverService.getCategory('curated');
  }

  @Get('authentic')
  authentic() {
    return this.discoverService.getCategory('authentic');
  }

  @Get('heads-up')
  headsUp() {
    return this.discoverService.getCategory('heads_up');
  }
}

@Controller('ranks')
export class RankController {
  constructor(private readonly discoverService: DiscoverService) {}

  @Get(':category')
  list(@Param('category') category: string) {
    return this.discoverService.getRanksByCategory(category);
  }

  @Get(':category/:rankId')
  detail(@Param('category') category: string, @Param('rankId') rankId: string) {
    return this.discoverService.getRankById(category, rankId);
  }
}
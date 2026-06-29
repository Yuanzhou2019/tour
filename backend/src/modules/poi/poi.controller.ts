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
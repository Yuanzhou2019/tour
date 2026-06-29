import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { PoiService } from './poi.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

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

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() dto: any) {
    return this.poiService.create(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: any) {
    return this.poiService.update(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.poiService.delete(id);
  }
}
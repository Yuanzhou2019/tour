import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { DiscoverService } from './discover.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

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

  @UseGuards(JwtAuthGuard)
  @Post()
  createCard(@Body() dto: any) {
    return this.discoverService.createCard(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  updateCard(@Param('id') id: string, @Body() dto: any) {
    return this.discoverService.updateCard(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  deleteCard(@Param('id') id: string) {
    return this.discoverService.deleteCard(id);
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

  @UseGuards(JwtAuthGuard)
  @Post()
  createRank(@Body() dto: any) {
    return this.discoverService.createRank(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  updateRank(@Param('id') id: string, @Body() dto: any) {
    return this.discoverService.updateRank(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  deleteRank(@Param('id') id: string) {
    return this.discoverService.deleteRank(id);
  }
}
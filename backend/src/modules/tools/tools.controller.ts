import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ToolsService } from './tools.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('tools')
export class ToolsController {
  constructor(private readonly toolsService: ToolsService) {}

  @Get('fx-rates')
  async fx(@Query('from') from: string, @Query('to') to: string) {
    if (from && to) {
      return this.toolsService.getFxRate(from, to);
    }
    return this.toolsService.listAllFxRates();
  }

  @Get('emergency')
  emergency(@Query('country') country?: string) {
    return this.toolsService.listEmergency(country);
  }

  @Get('phrases')
  async phrases(@Query('category') category?: string) {
    if (category) {
      return this.toolsService.listPhrasesByCategory(category);
    }
    return this.toolsService.listAllPhrases();
  }

  @Get('phrases/:category')
  phrasesByCategory(@Param('category') category: string) {
    return this.toolsService.listPhrasesByCategory(category);
  }

  @UseGuards(JwtAuthGuard)
  @Post('emergency')
  createEmergency(@Body() dto: any) {
    return this.toolsService.createEmergency(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('emergency/:id')
  updateEmergency(@Param('id') id: string, @Body() dto: any) {
    return this.toolsService.updateEmergency(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete('emergency/:id')
  deleteEmergency(@Param('id') id: string) {
    return this.toolsService.deleteEmergency(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post('phrases')
  createPhrase(@Body() dto: any) {
    return this.toolsService.createPhrase(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('phrases/:id')
  updatePhrase(@Param('id') id: string, @Body() dto: any) {
    return this.toolsService.updatePhrase(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete('phrases/:id')
  deletePhrase(@Param('id') id: string) {
    return this.toolsService.deletePhrase(id);
  }
}
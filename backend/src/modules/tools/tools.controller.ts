import { Controller, Get, Param, Query } from '@nestjs/common';
import { ToolsService } from './tools.service';

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
}
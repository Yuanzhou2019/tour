import { Entity, PrimaryColumn, Column, UpdateDateColumn } from 'typeorm';

@Entity('fx_rates')
export class FxRate {
  @PrimaryColumn({ length: 8 })
  fromCurrency!: string; // USD

  @PrimaryColumn({ length: 8 })
  toCurrency!: string; // CNY

  @Column({ type: 'real' })
  rate!: number;

  @UpdateDateColumn()
  updatedAt!: Date;
}
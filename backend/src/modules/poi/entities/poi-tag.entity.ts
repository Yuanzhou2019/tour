import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Poi } from './poi.entity';

@Entity('poi_tags')
export class PoiTag {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 64 })
  tagKey!: string; // e.g. "accepts_foreign_card", "english_menu"

  @Column({ length: 16 })
  category!: 'positive' | 'warning' | 'risk';

  @Column({ length: 200 })
  labelZh!: string;

  @Column({ length: 200 })
  labelEn!: string;

  @ManyToOne(() => Poi, poi => poi.tags, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'poi_id' })
  poi!: Poi;
}

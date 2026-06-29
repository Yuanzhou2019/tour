import { Entity, PrimaryGeneratedColumn, Column, OneToMany, Index } from 'typeorm';
import { PoiTag } from './poi-tag.entity';
import { PoiReputation } from './poi-reputation.entity';

@Entity('pois')
@Index(['city', 'category'])
export class Poi {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 200 })
  nameZh!: string;

  @Column({ length: 200 })
  nameEn!: string;

  @Column({ length: 500 })
  addressZh!: string;

  @Column({ length: 500 })
  addressEn!: string;

  @Column({ type: 'double precision' })
  lat!: number;

  @Column({ type: 'double precision' })
  lng!: number;

  @Column({ length: 32 })
  category!: string; // attraction | dining | lodging | shopping

  @Column({ length: 16, default: 'SH' })
  city!: string;

  @Column({ length: 50, nullable: true })
  contact?: string;

  @Column({ length: 200, nullable: true })
  openHours?: string;

  @Column({ type: 'text', array: true, default: [] })
  imageUrls!: string[];

  @Column({ type: 'text', nullable: true })
  descriptionZh?: string;

  @Column({ type: 'text', nullable: true })
  descriptionEn?: string;

  @OneToMany(() => PoiTag, tag => tag.poi)
  tags?: PoiTag[];

  @OneToMany(() => PoiReputation, rep => rep.poi)
  reputation?: PoiReputation;
}

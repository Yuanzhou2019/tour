import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Poi } from './poi.entity';

@Entity('poi_reputations')
export class PoiReputation {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => Poi, (poi) => poi.reputation, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'poi_id' })
  poi!: Poi;

  @Column({ type: 'real', default: 0 })
  overallScore!: number;

  @Column({ type: 'real', default: 0 })
  foreignFriendly!: number;

  @Column({ type: 'real', default: 0 })
  languageSupport!: number;

  @Column({ type: 'real', default: 0 })
  paymentEase!: number;

  @Column({ type: 'real', default: 0 })
  authenticity!: number;

  @Column({ type: 'real', default: 0 })
  value!: number;

  @Column({ default: false })
  officialVerified!: boolean;

  @Column({ type: 'text', array: true, default: [] })
  experienceTipsZh!: string[];

  @Column({ type: 'text', array: true, default: [] })
  experienceTipsEn!: string[];

  @UpdateDateColumn()
  updatedAt!: Date;
}

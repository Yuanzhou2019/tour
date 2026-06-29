import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('admin_users')
export class AdminUser {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 64, unique: true })
  username!: string;

  @Column({ length: 256 })
  passwordHash!: string;

  @Column({ length: 100, default: 'editor' })
  role!: string; // editor | reviewer | admin

  @CreateDateColumn()
  createdAt!: Date;
}

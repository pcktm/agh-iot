import { BaseEntity,
  Entity,
  PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { Device } from './device.entity';

@Entity()
export class User extends BaseEntity {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({unique: true})
  email: string;

  @Column({select: false})
  passwordHash: string;

  @OneToMany(() => Device, device => device.owner)
  devices: Device[];
  
  @CreateDateColumn({select: false})
  createdAt: Date;

  @UpdateDateColumn({select: false})
  updatedAt: Date;
}

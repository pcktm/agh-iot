import { BaseEntity, Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './user.entity';
import { LaundrySession } from './laundrySession.entity';

@Entity()
export class Device extends BaseEntity {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  lastSeenOnline: Date;

  @ManyToOne(() => User, user => user.devices)
  owner: User;

  @OneToMany(() => LaundrySession, laundrySession => laundrySession.device)
  laundrySessions: LaundrySession[];
}

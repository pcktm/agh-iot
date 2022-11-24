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

  // TODO: If device connects to the cloud and is not assigned to any user, put it in pairing mode
  @ManyToOne(() => User, user => user.devices, { onDelete: 'SET NULL'})
  owner: User;

  @OneToMany(() => LaundrySession, laundrySession => laundrySession.device)
  laundrySessions: LaundrySession[];
}

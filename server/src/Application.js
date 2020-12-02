import 'reflect-metadata';
import 'express-async-errors';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import path from 'path';
import { validateOrReject } from 'class-validator';
import { createConnection, getConnection } from 'typeorm';
import {
    initializeTransactionalContext,
    patchTypeORMRepositoryWithBaseRepository,
} from 'typeorm-transactional-cls-hooked';
import passport from 'passport';
import { ConnectionOptionGenerator } from './common/config/database/ConnectionOptionGenerator';
import { DatabaseEnv } from './common/env/DatabaseEnv';
import { EnvType } from './common/env/EnvType';
import { IndexRouter } from './router';
import { errorHandler } from './common/middleware/errorHandler';
import { NaverStrategy } from './common/config/passport/NaverStrategy';
import { JwtStrategy } from './common/config/passport/JwtStrategy';

export class Application {
    constructor() {
        this.httpServer = express();
    }

    listen(port) {
        return new Promise((resolve) => {
            this.httpServer.listen(port, () => {
                resolve();
            });
        });
    }

    async initialize() {
        await this.initEnvironment();
        this.initPassport();
        this.registerMiddleware();
        await this.initDatabase();
    }

    async initEnvironment() {
        dotenv.config();
        if (!EnvType.contains(process.env.NODE_ENV)) {
            throw new Error(
                '잘못된 NODE_ENV 입니다. {production, development, local, test} 중 하나를 선택하십시오.',
            );
        }
        dotenv.config({
            path: path.join(`${process.cwd()}/.env.${process.env.NODE_ENV}`),
        });

        this.databaseEnv = new DatabaseEnv();
        await validateOrReject(this.databaseEnv);
    }

    async initDatabase() {
        initializeTransactionalContext();
        patchTypeORMRepositoryWithBaseRepository();
        this.connectionOptionGenerator = new ConnectionOptionGenerator(this.databaseEnv);
        await createConnection(this.connectionOptionGenerator.generateConnectionOption());
    }

    registerMiddleware() {
        this.httpServer.use(cors());
        this.httpServer.use(express.json());
        this.httpServer.use(express.urlencoded({ extended: false }));
        this.httpServer.use(IndexRouter());
        this.httpServer.use(errorHandler);
    }

    initPassport() {
        passport.use(new NaverStrategy());
        passport.use(new JwtStrategy());
    }

    async close() {
        await getConnection().close();
    }
}
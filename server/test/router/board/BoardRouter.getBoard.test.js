import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { Invitation } from '../../../src/model/Invitation';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('GET /api/board', () => {
    const app = new Application();
    let jwtUtil = null;

    beforeAll(async () => {
        await app.initialize();
        jwtUtil = JwtUtil.getInstance();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('GET /api/board를 호출할 때, Authorization header가 없으면 400을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            // when
            const response = await request(app.httpServer).get('/api/board').set({
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test('GET /api/board를 호출할 때, 권한이 없으면 401을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const token = 'Bearer fakeToken';

            // when
            const response = await request(app.httpServer).get('/api/board').set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(401);
        });
    });

    test('GET /api/board가 정상적으로 호출되었을 때, 200을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };
            const user2 = { name: 'user2', socialId: '1244', profileImageUrl: 'image' };

            const userRepository = getRepository(User);
            const createUser1 = userRepository.create(user1);
            const createUser2 = userRepository.create(user2);
            const [createdUser1, createdUser2] = await userRepository.save([
                createUser1,
                createUser2,
            ]);

            const token = await jwtUtil.generateAccessToken({
                userId: createdUser2.id,
                username: createdUser2.name,
            });

            const boardRepository = getRepository(Board);
            const board1 = { id: 1, title: 'board1', creator: createdUser1.id, color: '#000000' };
            const board2 = { id: 2, title: 'board2', creator: createdUser2.id, color: '#000000' };
            const createBoard1 = boardRepository.create(board1);
            const createBoard2 = boardRepository.create(board2);
            const [createdBoard1] = await boardRepository.save([createBoard1, createBoard2]);

            const invitationRepository = getRepository(Invitation);
            const invitedBoard = { user: createdUser2.id, board: createdBoard1.id };
            const createInvitedBoard = invitationRepository.create(invitedBoard);
            await invitationRepository.save(createInvitedBoard);

            // when
            const response = await request(app.httpServer).get('/api/board').set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(200);
            const { myBoards, invitedBoards } = response.body;
            expect(myBoards).toHaveLength(1);
            expect(invitedBoards).toHaveLength(1);
        });
    });
});

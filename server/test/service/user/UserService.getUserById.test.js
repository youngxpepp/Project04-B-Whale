import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { EntityNotFoundError } from '../../../src/common/error/EntityNotFoundError';
import { User } from '../../../src/model/User';
import { UserService } from '../../../src/service/UserService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('UserService.getUserById() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initialize();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('user0을 조회했을 때 user0 반환', async () => {
        const userService = UserService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user0 = em.create(User, {
                socialId: '1234567890',
                name: 'geonhonglee',
                profileImageUrl: '',
            });
            await em.save(user0);

            // when
            const newUser0 = await userService.getUserById(user0.id);

            // then
            expect(newUser0.id).toEqual(user0.id);
        });
    });

    test('없는 사용자 조회했을 때 EntityNotFoundError 발생', async () => {
        const userService = UserService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            try {
                await userService.getUserById(0);
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(EntityNotFoundError);
            }
        });
    });
});

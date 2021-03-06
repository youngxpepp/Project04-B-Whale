import { Router } from 'express';
import { BoardService } from '../service/BoardService';
import { ListService } from '../service/ListService';

export const BoardRouter = () => {
    const router = Router();

    router.get('/', async (req, res) => {
        const boardService = BoardService.getInstance();
        const { id } = req.user;
        const data = await boardService.getBoardsByUserId(id);
        res.status(200).json(data);
    });

    router.post('/', async (req, res) => {
        const boardService = BoardService.getInstance();
        const createdBoardId = await boardService.createBoard({
            userId: req.user.id,
            title: req.body.title,
            color: req.body.color,
        });
        res.status(201).json({ id: createdBoardId });
    });

    router.get('/:id', async (req, res) => {
        const boardService = BoardService.getInstance();
        const detailBoard = await boardService.getDetailBoard(req.user.id, req.params.id);
        res.status(200).json(detailBoard);
    });

    router.post('/:id/invitation', async (req, res) => {
        const boardService = BoardService.getInstance();
        await boardService.inviteUserIntoBoard(req.user.id, req.params.id, req.body.userId);
        res.sendStatus(201);
    });

    router.put('/:id', async (req, res) => {
        const boardService = BoardService.getInstance();
        await boardService.updateBoard(req.user.id, req.params.id, req.body.title);
        res.sendStatus(204);
    });

    router.post('/:id/list', async (req, res) => {
        const listService = ListService.getInstance();
        const createdList = await listService.createList(
            req.user.id,
            req.params.id,
            req.body.title,
        );
        res.status(201).json(createdList);
    });

    router.delete('/:id', async (req, res) => {
        const boardService = BoardService.getInstance();
        const config = {
            userId: req.user.id,
            boardId: req.params.id,
        };
        await boardService.deleteBoard(config);
        res.sendStatus(204);
    });

    router.delete('/:id/invitation/', async (req, res) => {
        const boardService = BoardService.getInstance();
        await boardService.exitBoard(req.user.id, req.params.id);
        res.sendStatus(204);
    });

    return router;
};

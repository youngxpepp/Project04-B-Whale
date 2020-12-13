import React, { useContext, useEffect, useRef, useState } from 'react';
import styled from 'styled-components';
import BoardDetailContext from '../../context/BoardDetailContext';
import { updateBoardTitle } from '../../utils/boardRequest';

const MenuDiv = styled.div`
    display: flex;
    position: relative;
    justify-content: space-between;
    line-height: 30px;
    align-items: center;
    width: 100%;
    min-height: 30px;
    padding: 5px 0;
`;

const BoardTitle = styled.span`
    margin-right: 2%;
    border-radius: 4px;
    padding: 5px 5px;
    resize: none;
    margin-left: 2em;
    ${(props) =>
        props.state === 'span' &&
        `&:hover {
            cursor: pointer;
            opacity: 0.4;
            background-color: gray;
            color: white;
        }`};
`;

const BoardInput = styled.input`
    width: ${(props) => (props.width <= 0 ? 30 : props.width * 15)}px;
    height: 30px;
    position: relative;
    border-radius: 4px;
    margin-left: 2em;
    margin-right: 2%;
    z-index: 3;
    &:focus {
        outline: 1px solid blue;
    }
`;

const ButtonForGettingInvitedUser = styled.button`
    border-radius: 4px;
    padding: 5px 10px;
    margin-right: 2%;
    background-color: rgba(20, 197, 247, 0.17);
    &:hover {
        background-color: gray;
        opacity: 0.5;
        color: white;
    }
`;

const InviteButton = styled.button`
    border-radius: 4px;
    padding: 5px 10px;
    z-index: 9999;
    background-color: rgba(20, 197, 247, 0.17);
    &:hover {
        background-color: gray;
        opacity: 0.5;
        color: white;
    }
`;

const MenuButton = styled.button`
    display: ${(props) => (props.sidebarDisplay ? 'none' : 'block')};
    margin-right: 5%;
    border-radius: 4px;
    padding: 5px 10px;
    background-color: rgba(20, 197, 247, 0.17);
    &:hover {
        background-color: gray;
        opacity: 0.5;
        color: white;
    }
`;

const DimmedForInput = styled.div`
    display: ${(props) => (props.inputState === 'input' ? 'inline-block' : 'none')};
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
    z-index: 2;
`;

const MenuWrapper = styled.div`
    width: 50%;
    display: flex;
    justify-content: flex-end;
    padding: 5px 0;
`;

const TopMenu = ({
    sidebarDisplay,
    setInvitedDropdownDisplay,
    setAskoverDropdownDisplay,
    setSidebarDisplay,
}) => {
    const { boardDetail, setBoardDetail } = useContext(BoardDetailContext);
    const [inputState, setInputState] = useState('span');
    const [inputContent, setInputContent] = useState('');

    useEffect(() => {
        setInputContent(boardDetail.title);
    }, [boardDetail]);

    const inputTag = useRef();

    const changeBoardTitle = async (evt) => {
        if (evt.keyCode === 13) {
            if (!inputContent || inputContent === boardDetail.title) {
                setInputContent(boardDetail.title);
                setInputState('span');
                return;
            }
            await updateBoardTitle(boardDetail.id, inputContent);
            setBoardDetail({
                ...boardDetail,
                title: inputContent,
            });
            setInputState('span');
        }
    };

    const dimmedClickHandler = async () => {
        if (!inputContent || inputContent === boardDetail.title) {
            setInputContent(boardDetail.title);
            setInputState('span');
            return;
        }
        await updateBoardTitle(boardDetail.id, inputContent);
        setBoardDetail({
            ...boardDetail,
            title: inputContent,
        });
        setInputState('span');
    };

    return (
        <MenuDiv>
            <div style={{ width: '50%' }}>
                {inputState === 'span' && (
                    <BoardTitle state={inputState} onClick={() => setInputState('input')}>
                        {boardDetail.title}
                    </BoardTitle>
                )}
                {inputState === 'input' && (
                    <>
                        <BoardInput
                            width={inputContent.length}
                            value={inputContent}
                            onChange={(evt) => setInputContent(evt.target.value)}
                            autoFocus="autoFocus"
                            onKeyDown={changeBoardTitle}
                            ref={inputTag}
                        />
                        <DimmedForInput inputState={inputState} onClick={dimmedClickHandler} />
                    </>
                )}
                <ButtonForGettingInvitedUser
                    onClick={(evt) =>
                        setInvitedDropdownDisplay({
                            visible: true,
                            offsetY: evt.target.getBoundingClientRect().left,
                            offsetX: evt.target.getBoundingClientRect().top,
                        })
                    }
                >
                    참여자 목록
                </ButtonForGettingInvitedUser>
                <InviteButton
                    onClick={(evt) =>
                        setAskoverDropdownDisplay({
                            visible: true,
                            offsetY: evt.target.getBoundingClientRect().left,
                            offsetX: evt.target.getBoundingClientRect().top,
                        })
                    }
                >
                    초대하기
                </InviteButton>
            </div>
            <MenuWrapper>
                <MenuButton sidebarDisplay={sidebarDisplay} onClick={() => setSidebarDisplay(true)}>
                    메뉴
                </MenuButton>
            </MenuWrapper>
        </MenuDiv>
    );
};

export default TopMenu;
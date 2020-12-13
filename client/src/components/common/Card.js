import React from 'react';
import styled from 'styled-components';

const CardWrapper = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: ${(props) => props.width};
    height: ${(props) => props.height};
    padding-left: 1rem;
    border-radius: 1rem;
    box-shadow: 0 0.2rem 0rem ${(props) => props.theme.lightGrayColor};
    color: #586069;
    background-color: white;
    margin-bottom: 10px;
    cursor: pointer;
    &:hover {
        background-color: ${(props) => props.theme.lightGrayColor};
    }
`;

const CardTitle = styled.div`
    font-size: ${(props) => (props.fontSize?.titleSize ? props.fontSize?.titleSize : '2rem')};
    margin-bottom: 0.5rem;
`;

const CardDueDateCommentCountFlexBox = styled.div`
    display: flex;
`;

const CardDueDate = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    height: 1.5rem;
    margin: 0 1rem 0 0;
    font-size: ${(props) => (props.fontSize?.dueDateSize ? props.fontSize.dueDateSize : '')};
`;

const CardCommentCount = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    width: 2rem;
    height: 1.5rem;
    padding: 0 1rem;
`;

const Card = ({ width, height, cardTitle, cardDueDate, cardCommentCount, fontSize }) => {
    return (
        <CardWrapper width={width} height={height}>
            <CardTitle fontSize={fontSize}>{cardTitle}</CardTitle>
            <CardDueDateCommentCountFlexBox>
                <CardDueDate fontSize={fontSize}>{cardDueDate}</CardDueDate>
                <CardCommentCount>{cardCommentCount}</CardCommentCount>
            </CardDueDateCommentCountFlexBox>
        </CardWrapper>
    );
};

export default Card;
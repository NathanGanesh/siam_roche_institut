import React, {Component, useContext, useEffect} from 'react';
import {ButtonWithIcon, StyledButtonDelete, StyledButtonLink} from "../../styled/globals/StyledRouterLink";
import {FlexBox} from "../../styled/styles";
import {InvestigationContext} from "../../context/InvestigationContext";
import {ContainerKamerInfo, GridImages} from "../../styled/globals/StyledFlexBoxContainer";
import styled from "styled-components";
import {useHistory} from "react-router-dom";
export default function InvestigationListItem(props){
    let history = useHistory();
    useEffect(() => {
        console.log(props);
    });

    const handleOnClick = (e, naam) => {
        history.push(`/investigation/${naam}`)
    }

    return <InvestigationListItemStyled onClick={(e) => handleOnClick(e, props.investigation.name)}>
        <ContainerKamerInfo>

        <p>{props.investigation.name}</p>
        <p>{props.investigation.summary}</p>
        </ContainerKamerInfo>
    </InvestigationListItemStyled>
}

const InvestigationListItemStyled = styled(FlexBox)`
  display: flex;
  width: 100%;
  flex-direction: row;
  cursor: pointer;
`
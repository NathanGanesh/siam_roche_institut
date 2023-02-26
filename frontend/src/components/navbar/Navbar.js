import React, { Component } from 'react';
import { Image } from "../../styled/Image";
import Logo from "../../images/logo.png";
import { StyledRouterLink } from '../../styled/globals/StyledRouterLink';
import { FlexBox, LinkFlexBoxContainer, StyledFlexBoxContainer } from '../../styled/styles';
import SideBar from "./Sidebar";
import InputWithImage from "../../styled/globals/Input";
const Navbar = () => {

    const onChange = () => {

    }
    return (
        <StyledFlexBoxContainer cssClass="link-box-container" x="space-between">
            <FlexBox >
            <StyledRouterLink activeClassName={"none"} to={"/"}>
                <Image logo={Logo} width={52} height={48} />
                The innocents
            </StyledRouterLink>
            <InputWithImage placeHolderName="name, location, company" icon="fa-search" />
        </FlexBox>
            <LinkFlexBoxContainer >
                <StyledRouterLink to={"/info"} active={"active"}  p={"hover"}>
                    datasets
                </StyledRouterLink>
                <StyledRouterLink to={"/investigation"}  p={"hover"}>
                    Investigation
                </StyledRouterLink>
            </LinkFlexBoxContainer>
        </StyledFlexBoxContainer>

    );
}

export default Navbar;
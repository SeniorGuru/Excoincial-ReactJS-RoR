import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import { Typography, Box } from "@material-ui/core";
import Tabsection from './Tabsection';
import Content from './Content';


function Rewardcenter(props) {
    const { selectRewardcenter } = props;
    useEffect(() => {
        selectRewardcenter();
      }, [selectRewardcenter]);
    return (
        <Fragment>
            <Box mt={4} style={{paddingLeft:50}}>
                <Typography variant="h3" gutterBottom>
                Reward Center
                </Typography>
            </Box>
            <Tabsection></Tabsection>
            <Content></Content>
        </Fragment>        
    );
}

Rewardcenter.propTypes = {
    selectRewardcenter: PropTypes.func.isRequired
  };

export default Rewardcenter;
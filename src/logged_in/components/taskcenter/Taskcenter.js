import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import { Typography, Box } from "@material-ui/core";
import Content from './Content';


function Taskcenter(props) {
    const { selectTaskcenter } = props;
    useEffect(() => {
        selectTaskcenter();
      }, [selectTaskcenter]);
    return (
        <Fragment>
            <Content />
        </Fragment>        
    );
}

Taskcenter.propTypes = {
  selectTaskcenter: PropTypes.func.isRequired
  };

export default Taskcenter;
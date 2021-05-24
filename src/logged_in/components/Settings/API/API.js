import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import { Typography, Box } from "@material-ui/core";
import Content from './Content';


function API(props) {
    const { selectAPI } = props;
    useEffect(() => {
      selectAPI();
      }, [selectAPI]);
    return (
        <Fragment>
            <Content />
        </Fragment>        
    );
}

API.propTypes = {
  selectAPI: PropTypes.func.isRequired
  };

export default API;
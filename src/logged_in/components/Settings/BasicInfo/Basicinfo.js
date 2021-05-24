import React, { Fragment, useEffect } from "react";
import PropTypes from "prop-types";
import { Typography, Box } from "@material-ui/core";
import Content from './Content';


function BasicInfo(props) {
    const { selectBasicinfo } = props;
    useEffect(() => {
      selectBasicinfo();
      }, [selectBasicinfo]);
    return (
        <Fragment>
            <Content />
        </Fragment>        
    );
}

BasicInfo.propTypes = {
  selectBasicinfo: PropTypes.func.isRequired
  };

export default BasicInfo;
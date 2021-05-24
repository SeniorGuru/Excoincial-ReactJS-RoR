import React from "react";
import PropTypes from "prop-types";
import {
  IconButton,
  Box,
  withTheme
} from "@material-ui/core";
import CloseImage from "../../assets/images/cross.png";

function DialogTitleWithCloseIcon(props) {
  const {
    onClose,
    disabled,
  } = props;
  return (
      <Box position="absolute" top={0} right={0}>
        <IconButton
          onClick={onClose}
          disabled={disabled}
          aria-label="Close"
        >
          <img
            src={CloseImage}
            alt=""
          />
        </IconButton>
      </Box>
  );
}

DialogTitleWithCloseIcon.propTypes = {
  theme: PropTypes.object,
  paddingBottom: PropTypes.number,
  onClose: PropTypes.func,
  disabled: PropTypes.bool,
  title: PropTypes.string,
  disablePadding: PropTypes.bool
};

export default withTheme(DialogTitleWithCloseIcon);

import React from "react";
import PropTypes from "prop-types";
import { Dialog, DialogContent, Box, withStyles, Hidden } from "@material-ui/core";
import DialogCloseIcon from "./DialogCloseIcon";
import DialogImage from "../../assets/images/Login-&-Signup.png";
import LogoImage from "../../assets/images/Logo.png";

const styles = theme => ({
  dialogPaper: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    // paddingBottom: theme.spacing(3),
    maxWidth: 840,
    [theme.breakpoints.down("sm")]: {
      maxWidth: 420,
    },
  },
  actions: {
    marginTop: theme.spacing(2)
  },
  dialogPaperScrollPaper: {
    maxHeight: "none"
  },
  dialogContent: {
    display: `flex`,
    paddingTop: `0px !important`,
    paddingBottom: 0
  },
  dialogImage:{
    width: `50%`,
  },
  dialogContent1: {
    width: `50%`,
    [theme.breakpoints.down("sm")]: {
      width: `100%`,
    },
    padding: `15px`,
    marginTop: `30px`
  },
  dialogImage1: {
    width: `100%`,
    height: `100%`
  },
  dialogImage2: {
    position: `absolute`,
    width: `20%`,
    top: `25px`,
    left: `25px`
  }
});

/**
 * A Wrapper around the Dialog component to create centered
 * Login, Register or other Dialogs.
 */
function FormDialog(props) {
  const {
    classes,
    open,
    onClose,
    loading,
    headline,
    onFormSubmit,
    content,
    actions,
    hideBackdrop
  } = props;
  return (
    <Dialog
      open={open}
      onClose={onClose}
      disableBackdropClick={loading}
      disableEscapeKeyDown={loading}
      classes={{
        paper: classes.dialogPaper,
        paperScrollPaper: classes.dialogPaperScrollPaper
      }}
      hideBackdrop={hideBackdrop ? hideBackdrop : false}
    >
      <DialogCloseIcon
        title={headline}
        onClose={onClose}
        disabled={loading}
      />
      <DialogContent className={classes.dialogContent}>
        <Hidden smDown>
          <div className={classes.dialogImage}>
            <img
              src={DialogImage}
              className={classes.dialogImage1}
              alt=""
            />
            <img
              src={LogoImage}
              className={classes.dialogImage2}
              alt=""
            />  
          </div>          
        </Hidden>
        <div className={classes.dialogContent1}>
          <form onSubmit={onFormSubmit}>
            <div>{content}</div>
            <Box width="100%" className={classes.actions}>
              {actions}
            </Box>
          </form>
        </div>
      </DialogContent>
    </Dialog>
  );
}

FormDialog.propTypes = {
  classes: PropTypes.object.isRequired,
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  headline: PropTypes.string.isRequired,
  loading: PropTypes.bool.isRequired,
  onFormSubmit: PropTypes.func.isRequired,
  content: PropTypes.element.isRequired,
  actions: PropTypes.element.isRequired,
  hideBackdrop: PropTypes.bool.isRequired
};

export default withStyles(styles, { withTheme: true })(FormDialog);

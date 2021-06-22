import React, { useEffect } from "react";
import PropTypes from "prop-types";
import { Link } from "react-router-dom";
import { makeStyles } from '@material-ui/core/styles';
import {
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Drawer,
  withStyles,
  IconButton,
  Typography,
  withWidth,
  isWidthUp,
  Toolbar
} from "@material-ui/core";
import CloseIcon from "@material-ui/icons/Close";

const styles = theme => ({
  closeIcon: {
    marginRight: theme.spacing(0.5)
  },
  headSection: {
    width: 200
  },
  blackList: {
    backgroundColor: theme.palette.common.black,
    height: "100%"
  },
  noDecoration: {
    textDecoration: "none !important"
  }
});

const useStyles = makeStyles((theme) => ({
  paper: {
    backgroundColor: `rgb(52 58 64)`,
    marginTop:56,
  },
}));
function NavigationDrawer(props) {
  const {
    width,
    open,
    onClose,
    anchor,
    classes,
    menuItems,
    selectedItem,
    theme
  } = props;

  useEffect(() => {
    window.onresize = () => {
      if (isWidthUp("sm", width) && open) {
        onClose();
      }
    };
  }, [width, open, onClose]);
  const myClasses = useStyles();
  return (
    <Drawer variant="temporary" open={open} onClose={onClose} anchor={anchor} classes={{ paper: myClasses.paper }}>
      <List className={classes.blackList}>
        {menuItems.map(element => {
          if (element.link) {
            return (
              <Link
                key={element.name}
                to={element.link}
                className={classes.noDecoration}
                onClick={onClose}
              >
                <ListItem
                  button
                  selected={selectedItem === element.name}
                  /**
                   * We disable ripple as it will make a weird animation
                   * with primary and secondary color
                   */
                  disableRipple
                  disableTouchRipple
                >
                  <ListItemIcon>{element.icon}</ListItemIcon>
                  <ListItemText
                    primary={
                      <Typography variant="subtitle1" className="text-white">
                        {element.name}
                      </Typography>
                    }
                  />
                </ListItem>
              </Link>
            );
          }
          return (
            <ListItem button key={element.name} onClick={element.onClick}>
              <ListItemIcon>{element.icon}</ListItemIcon>
              <ListItemText
                primary={
                  <Typography variant="subtitle1" className="text-white">
                    {element.name}
                  </Typography>
                }
              />
            </ListItem>
          );
        })}
      </List>
    </Drawer>
  );
}

NavigationDrawer.propTypes = {
  anchor: PropTypes.string.isRequired,
  theme: PropTypes.object.isRequired,
  open: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  menuItems: PropTypes.arrayOf(PropTypes.object).isRequired,
  classes: PropTypes.object.isRequired,
  width: PropTypes.string.isRequired,
  selectedItem: PropTypes.string
};

export default withWidth()(
  withStyles(styles, { withTheme: true })(NavigationDrawer)
);

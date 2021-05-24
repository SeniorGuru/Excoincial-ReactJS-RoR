import React, { Fragment, useRef, useCallback, useState } from "react";
import { Link } from "react-router-dom";
import PropTypes from "prop-types";
import {
  AppBar,
  Toolbar,
  Drawer,
  Typography,
  List,
  IconButton,
  ListItem,
  ListItemIcon,
  Hidden,
  Box,
  withStyles,
  withWidth,
} from "@material-ui/core";
import DashboardIcon from "@material-ui/icons/Dashboard";
import PowerSettingsNewIcon from "@material-ui/icons/PowerSettingsNew";
import MenuIcon from "@material-ui/icons/Menu";
import MessagePopperButton from "./MessagePopperButton";
import NavigationDrawer from "../../../shared/components/NavigationDrawer";
import LogoImage from "../../../assets/images/Logo.png";
import AppIcon from "@material-ui/icons/Apps";
import AccountCircleOutlinedIcon from '@material-ui/icons/AccountCircleOutlined';
import LanguageIcon from "@material-ui/icons/Language";
import CurrencyIcon from "@material-ui/icons/Brightness3";
import MonetizationOnOutlinedIcon from '@material-ui/icons/MonetizationOnOutlined';
import ShopTwoOutlinedIcon from '@material-ui/icons/ShopTwoOutlined';
import SecurityOutlinedIcon from '@material-ui/icons/SecurityOutlined';
import EmojiEventsOutlinedIcon from '@material-ui/icons/EmojiEventsOutlined';
import AssignmentOutlinedIcon from '@material-ui/icons/AssignmentOutlined';
import TuneOutlinedIcon from '@material-ui/icons/TuneOutlined';
import SportsKabaddiOutlinedIcon from '@material-ui/icons/SportsKabaddiOutlined';
import ChevronRightIcon from '@material-ui/icons/ChevronRight';


const styles = theme => ({
  appBar: {
    boxShadow: theme.shadows[6],
    backgroundColor: theme.palette.common.white,
    transition: theme.transitions.create(["width", "margin"], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen
    }),
    [theme.breakpoints.down("xs")]: {
      width: "100%",
      marginLeft: 0
    },
  },
  appBarToolbar: {
    display: "flex",
    justifyContent: "space-between",
    paddingLeft: theme.spacing(1),
    paddingRight: theme.spacing(1),
    [theme.breakpoints.up("sm")]: {
      paddingLeft: theme.spacing(2),
      paddingRight: theme.spacing(2)
    },
    [theme.breakpoints.up("md")]: {
      paddingLeft: theme.spacing(3),
      paddingRight: theme.spacing(3)
    },
    [theme.breakpoints.up("lg")]: {
      paddingLeft: theme.spacing(4),
      paddingRight: theme.spacing(4)
    },
    backgroundColor: theme.palette.secondary.main
  },
  accountAvatar: {
    backgroundColor: theme.palette.secondary.main,
    height: 24,
    width: 24,
    marginLeft: theme.spacing(2),
    marginRight: theme.spacing(2),
    [theme.breakpoints.down("xs")]: {
      marginLeft: theme.spacing(1.5),
      marginRight: theme.spacing(1.5)
    }
  },
  noDecoration: {
		textDecoration: "none !important",
		fontSize: 16,
		[theme.breakpoints.down("lg")]: {
			fontSize: 13
		},
		[theme.breakpoints.down("md")]: {
			fontSize: 10
		},
		marginLeft: 10,
	},
  drawerPaper: {
    height: "100%vh",
    zIndex: 101,
    whiteSpace: "nowrap",
    border: 0,
    width: theme.spacing(7),
    overflowX: "hidden",
    marginTop: theme.spacing(8),
    [theme.breakpoints.up("sm")]: {
      width: `350px`
    },
    backgroundColor: theme.palette.background.default,
    boxShadow: theme.shadows[6],
    paddingRight: 20,
    paddingLeft: 20
  },
  smBordered: {
    [theme.breakpoints.down("xs")]: {
      borderRadius: "50% !important"
    }
  },
  menuLink: {
    textDecoration: "none",
    color: theme.palette.text.primary
  },
  iconListItem: {
    width: "auto",
    borderRadius: theme.shape.borderRadius,
    paddingTop: 11,
    paddingBottom: 11,
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1)
  },
  textPrimary: {
    color: theme.palette.primary.main
  },
  mobileItemSelected: {
    backgroundColor: `${theme.palette.primary.main} !important`
  },
  brandText: {
    fontFamily: "'Baloo Bhaijaan', cursive",
    fontWeight: 400
  },
  username: {
    paddingLeft: 0,
    paddingRight: theme.spacing(2)
  },
  justifyCenter: {
    justifyContent: "left",
    minWidth: `fit-content !important`,
    padding: 10,
    borderRadius: 30,
    backgroundColor: `rgb(200,200,200)`
  },
  permanentDrawerListItem: {
    justifyContent: "left",
    paddingTop: theme.spacing(2),
    paddingBottom: theme.spacing(2)
  },
  mainMenu: {
		textDecoration: "none !important",
		fontSize: 16,
		[theme.breakpoints.down("md")]: {
			marginLeft: 10,
			fontSize: 13
		},
		[theme.breakpoints.down("sm")]: {
			marginLeft: 5,
			fontSize: 10,
		},
		fontWeight: theme.typography.h6.fontWeight,
		color: theme.palette.common.white,
		marginLeft: 15,
  },
  justifyLeft:{
    paddingLeft: 20
  },
  textYellow:{
    color: `#ff0`
  },
  textPink:{
    color: `#FF4081`
  },
  textRed: {
    color: theme.palette.primary.main
  },
  textGreen: {
    color: `#2a7d2a`
  },
  textPurple: {
    color: `#410992`
  },
  textBlue: {
    color: `#2ebbe0`
  }
});

function NavBar(props) {
  const { selectedTab, messages, classes} = props;
  // Will be use to make website more accessible by screen readers
  const links = useRef([]);
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);

  const openMobileDrawer = useCallback(() => {
    setIsMobileOpen(true);
  }, [setIsMobileOpen]);

  const closeMobileDrawerfunc = useCallback(() => {
    setIsMobileOpen(false);
  }, [setIsMobileOpen]);

  function closeMobileDrawer(){
    closeMobileDrawerfunc();
    isSettingsOpen === true?setIsSettingsOpen(!isSettingsOpen):setIsSettingsOpen(isSettingsOpen);
  }

  const menuItems = [
    {
      link: "/excoincial/dashboard",
      name: "Dashboard",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <DashboardIcon
            className={
              selectedTab === "Dashboard" ? classes.textPrimary : "text-black"
            }
            fontSize="small"
          />
        ),
        mobile: <DashboardIcon className="text-black" />
      }
    },
    {
      link: "/excoincial/payment",
      name: "Payment",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <MonetizationOnOutlinedIcon
            className={
              selectedTab === "Payment" ? classes.textPrimary : classes.textYellow
            }
            fontSize="small"
          />
        ),
        mobile: <MonetizationOnOutlinedIcon className={classes.textYellow} />
      }
    },
    {
      link: "/excoincial/buy-sell",
      name: "Buy/Sell",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <ShopTwoOutlinedIcon
            className={
              selectedTab === "Buy/Sell" ? classes.textPrimary : "text-black"
            }
            fontSize="small"
          />
        ),
        mobile: <ShopTwoOutlinedIcon className="text-black" />
      }
    },
    {
      link: "/excoincial/security",
      name: "Security",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <SecurityOutlinedIcon
            className={
              selectedTab === "Security" ? classes.textPrimary : classes.textPink
            }
            fontSize="small"
          />
        ),
        mobile: <SecurityOutlinedIcon className={classes.textPink} />
      }
    },
    {
      link: "/excoincial/rewardcenter",
      name: "Reward Center",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <EmojiEventsOutlinedIcon
            className={
              selectedTab === "Reward Center" ? classes.textPrimary : classes.textRed
            }
            fontSize="small"
          />
        ),
        mobile: <EmojiEventsOutlinedIcon className={classes.textRed} />
      }
    },
    {
      link: "/excoincial/task-center",
      name: "Task Center",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <AssignmentOutlinedIcon
            className={
              selectedTab === "Task Center" ? classes.textPrimary : classes.textGreen
            }
            fontSize="small"
          />
        ),
        mobile: <AssignmentOutlinedIcon className={classes.textGreen} />
      }
    },
    {
      link: "/excoincial/settings",
      name: "Settings",
      onClick: () => setIsSettingsOpen(!isSettingsOpen),
      icon: {
        desktop: (
          <TuneOutlinedIcon
            className={
              selectedTab === "Settings" ? classes.textPrimary : classes.textPurple
            }
            fontSize="small"
          >
            <ChevronRightIcon/>
          </TuneOutlinedIcon>
        ),
        mobile: <TuneOutlinedIcon className={classes.textPurple} />
      },
      childrens: [
        {
          link: "/excoincial/basicinfo",
          name: "Basicinfo",
          onClick: closeMobileDrawerfunc,
          icon: {
            desktop: (
              <span>{
                selectedTab === "Settings" ? classes.textPrimary : classes.textPurple
              }</span>              
            ),
            mobile: <TuneOutlinedIcon className={classes.textPurple} />
          },
        },
        {
          link: "/excoincial/api",
          name: "API",
          onClick: closeMobileDrawerfunc,
          icon: {
            desktop: (
              <span>{
                selectedTab === "Settings" ? classes.textPrimary : classes.textPurple
              }</span>              
            ),
            mobile: <TuneOutlinedIcon className={classes.textPurple} />
          },
        },
        {
          link: "/excoincial/preferences",
          name: "Preferences",
          onClick: closeMobileDrawerfunc,
          icon: {
            desktop: (
              <span>{
                selectedTab === "Settings" ? classes.textPrimary : classes.textPurple
              }</span>              
            ),
            mobile: <TuneOutlinedIcon className={classes.textPurple} />
          },
        },
      ],
    },
    {
      link: "/excoincial/referral",
      name: "Referral",
      onClick: closeMobileDrawer,
      icon: {
        desktop: (
          <SportsKabaddiOutlinedIcon
            className={
              selectedTab === "Referral" ? classes.textPrimary : classes.textBlue
            }
            fontSize="small"
          />
        ),
        mobile: <SportsKabaddiOutlinedIcon className={classes.textBlue} />
      }
    },
    // {
    //   link: "/",
    //   name: "Logout",
    //   icon: {
    //     desktop: (
    //       <PowerSettingsNewIcon className="text-white" fontSize="small" />
    //     ),
    //     mobile: <PowerSettingsNewIcon className="text-white" />
    //   }
    // }
  ];
  return (
    <Fragment>
      <AppBar position="sticky" className={classes.appBar}>
        <Toolbar className={classes.appBarToolbar}>
          <Box display="flex" alignItems="center">
            <Hidden smUp>
              <Box mr={1}>
                <IconButton
                  aria-label="Open Navigation"
                  onClick={openMobileDrawer}
                  color="primary"
                >
                  <MenuIcon />
                </IconButton>
              </Box>
            </Hidden>
            <Hidden xsDown>
              <Link
                to="/"
                className={classes.brandText}
                display="inline"
              >
                <img
                  src={LogoImage}
                  className={classes.logo}
                  alt="Main Logo"
                />
              </Link>
            </Hidden>
          </Box>
          <div style={{display: `flex`, float: `left`}}>
            <Hidden smDown>
              <Link
                key={"menu-1"}
                to={""}
                className={classes.noDecoration}
                onClick={closeMobileDrawer}
              >
                <AppIcon color="primary" style={{marginTop:19, marginLeft: 30}}/>
              </Link>
              <Link
                key={"menu-markets"}
                to={"/markets"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Markets</h4>
              </Link>
              <Link
                key={"menu-support"}
                to={"/support"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Support</h4>
              </Link>
              <Link
                key={"menu-exchange"}
                to={"/exchange"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Exchange</h4>
              </Link>								
              <Link
                key={"menu-trading"}
                to={"/trading"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Trading</h4>
              </Link>
              <Link
                key={"menu-p2p"}
                to={"/p2p-dex"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>P2PDEX</h4>
              </Link>
              <Link
                key={"menu-products"}
                to={"/products"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Products</h4>
              </Link>
              <Link
                key={"menu-services"}
                to={"/services"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Services</h4>
              </Link>
              <Link
                key={"menu-vote"}
                to={"/vote"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>Vote</h4>
              </Link>
              <Link
                key={"menu-ico"}
                to={"/ico"}
                className={classes.mainMenu}
                onClick={closeMobileDrawer}
              >
                <h4 classes={classes.menuItem}>ICO</h4>
              </Link>
						</Hidden>
					</div>
          <Box
            display="flex"
            justifyContent="flex-end"
            alignItems="center"
            width="100%"
          >
            <Link
              key={"menu-wallets"}
              to={"/wallets"}
              className={classes.mainMenu}
              onClick={closeMobileDrawer}
            >
              <h4 classes={classes.menuItem}>Wallets</h4>
            </Link>
            <Link
              key={"menu-orders"}
              to={"/orders"}
              className={classes.mainMenu}
              onClick={closeMobileDrawer}
            >
              <h4 classes={classes.menuItem}>Orders</h4>
            </Link>
            <IconButton style={{padding: 0, marginLeft:10}}>
              <AccountCircleOutlinedIcon style={{color: `white`, fontSize:36}}/>
            </IconButton>
            <MessagePopperButton messages={messages} />
            <Link
              to="/"
              className={classes.noDecoration}
              onClick={closeMobileDrawer}
            >
              <LanguageIcon color="primary" style={{marginTop: 5}}/>
            </Link>
            <Link
              to="./blog"
              className={classes.noDecoration}
              onClick={closeMobileDrawer}
            >
              <CurrencyIcon color="primary" style={{transform: `rotate(135deg)`, marginTop:5}}/>
            </Link>
          </Box>
        </Toolbar>
      </AppBar>
      <Hidden xsDown>
        <Drawer //  both drawers can be combined into one for performance
          variant="permanent"
          classes={{
            paper: classes.drawerPaper
          }}
          open={false}
        >
          <List>
            {menuItems.map((element, index) => (
              <>
              <Link
                to={element.link}
                className={classes.menuLink}
                onClick={element.onClick}
                key={index}
                ref={node => {
                  links.current[index] = node;
                }}
              >
                {/* <Tooltip
                  title={element.name}
                  placement="right"
                  key={element.name}
                > */}
                  <ListItem
                    selected={selectedTab === element.name}
                    button
                    divider={index !== menuItems.length - 1}
                    className={classes.permanentDrawerListItem}
                    onClick={() => {
                      links.current[index].click();
                    }}
                    aria-label={
                      element.name === "Logout"
                        ? "Logout"
                        : `Go to ${element.name}`
                    }
                  >
                    <ListItemIcon className={classes.justifyCenter}>
                      {element.icon.desktop}
                    </ListItemIcon>
                    <Typography className={classes.justifyLeft}>{element.name}</Typography>
                  </ListItem>
                {/* </Tooltip> */}
              </Link>
              {element.name === 'Settings' && isSettingsOpen && (
                      <>
                        {
                          element.childrens.map((child) => (
                            <Link
                              to={child.link}
                              className={classes.menuLink}
                              onClick={child.onClick}
                              key={index}
                              ref={node => {
                                links.current[index] = node;
                              }}
                            >
                              {/* <Tooltip
                                title={element.name}
                                placement="right"
                                key={element.name}
                              > */}
                                <ListItem
                                  selected={selectedTab === child.name}
                                  button
                                  divider={index !== menuItems.length - 1}
                                  className={classes.permanentDrawerListItem}
                                  onClick={() => {
                                    links.current[index].click();
                                  }}
                                  aria-label={
                                    child.name === "Logout"
                                      ? "Logout"
                                      : `Go to ${child.name}`
                                  }
                                >
                                  <Typography className={classes.justifyLeft}>{child.name}</Typography>
                                </ListItem>
                              {/* </Tooltip> */}
                            </Link>
                          ))
                        }
                      </>
                    )}
              </>
            ))}
          </List>
        </Drawer>
      </Hidden>
      <NavigationDrawer
        menuItems={menuItems.map(element => ({
          link: element.link,
          name: element.name,
          icon: element.icon.mobile,
          onClick: element.onClick
        }))}
        anchor="left"
        open={isMobileOpen}
        selectedItem={selectedTab}
        onClose={closeMobileDrawer}
      />
    </Fragment>
  );
}

NavBar.propTypes = {
  messages: PropTypes.arrayOf(PropTypes.object).isRequired,
  selectedTab: PropTypes.string.isRequired,
  width: PropTypes.string.isRequired,
  classes: PropTypes.object.isRequired,
  openAddBalanceDialog: PropTypes.func.isRequired
};

export default withWidth()(withStyles(styles, { withTheme: true })(NavBar));

import { createMuiTheme, responsiveFontSizes } from "@material-ui/core";

// colors
const primary = "#de0d2c";
const secondary = "#070331";
const black = "#343a40";
const darkBlack = "rgb(36, 40, 44)";
const background = "#f5f5f5";
const warningLight = "rgba(253, 200, 69, .3)";
const warningMain = "rgba(253, 200, 69, .5)";
const warningDark = "rgba(253, 200, 69, .7)";

// border
const borderWidth = 2;
const borderColor = "rgba(0, 0, 0, 0.13)";

// breakpoints
const xl = 1920;
const lg = 1280;
const md = 960;
const sm = 600;
const xs = 0;

// spacing
const spacing = 8;

const theme = createMuiTheme({
  palette: {
    primary: { main: primary },
    secondary: { main: secondary },
    common: {
      black,
      darkBlack
    },
    warning: {
      light: warningLight,
      main: warningMain,
      dark: warningDark
    },
    // Used to shift a color's luminance by approximately
    // two indexes within its tonal palette.
    // E.g., shift from Red 500 to Red 300 or Red 700.
    tonalOffset: 0.2,
    background: {
      default: background
    },
    spacing
  },
  breakpoints: {
    // Define custom breakpoint values.
    // These will apply to Material-UI components that use responsive
    // breakpoints, such as `Grid` and `Hidden`. You can also use the
    // theme breakpoint functions `up`, `down`, and `between` to create
    // media queries for these breakpoints
    values: {
      xl,
      lg,
      md,
      sm,
      xs
    }
  },
  border: {
    borderColor: borderColor,
    borderWidth: borderWidth
  },
  overrides: {
    MuiAccordion: {
      root: {
        position: "static"
      }
    },
    MuiTableCell: {
      root: {
        paddingLeft: spacing * 2,
        paddingRight: spacing * 2,
        borderBottom: `${borderWidth}px solid ${borderColor}`,
        [`@media (max-width:  ${sm}px)`]: {
          paddingLeft: spacing,
          paddingRight: spacing
        }
      }
    },
    MuiDivider: {
      root: {
        backgroundColor: borderColor,
        height: borderWidth
      }
    },
    MuiPrivateNotchedOutline: {
      root: {
        borderWidth: borderWidth
      }
    },
    MuiListItem: {
      divider: {
        // borderBottom: `${borderWidth}px solid ${borderColor}`
        borderBottom: `0px solid ${borderColor}`
      },
      root:{
        '&$selected, &$selected:hover':{
          borderRadius: 5,
          borderLeft: `5px solid ${primary}`,
          backgroundColor: secondary,
          color: background
        }
      },
      button:{
        '&:hover':{
          // borderRadius: 5,
          // borderLeft: `5px solid ${primary}`,
          // backgroundColor: secondary
        }
      }     
    },
    MuiDialog: {
      paper: {
        width: "100%",
        marginLeft: spacing,
        marginRight: spacing
      },
      container:{
        background: `rgba(7,3,49,0.8)`
      }
    },
    MuiDialogContent: {
      root: {
        padding: `0px`,
      }
    },
    MuiTooltip: {
      tooltip: {
        backgroundColor: darkBlack
      }
    },
    MuiAccordionDetails: {
      root: {
        [`@media (max-width:  ${sm}px)`]: {
          paddingLeft: spacing,
          paddingRight: spacing
        }
      }
    },
    MuiButton: {
      root:{
        border: `1px solid ${primary}`,
        marginLeft: `5px`,
        borderRadius: `30px`,
        padding: `2px !important`,
        textTransform: `none`
      },
      label:{
        backgroundColor: primary,
        borderRadius: `30px`,
        padding: `2px 10px`
      }
    },
    MuiTab: {
      root: {
        minWidth: `fit-content !important`,
      }
    }
  },
  typography: {
    useNextVariants: true
  }
});

export default responsiveFontSizes(theme);

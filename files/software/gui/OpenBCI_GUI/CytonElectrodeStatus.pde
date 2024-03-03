import java.text.NumberFormat;

public enum ElectrodeState {
    GREYED_OUT(0, #717577),
    RED(1, #ff0000),
    YELLOW(2, #e6c700),
    GREEN(3, #00ff64),
    BLUE(4, #416080),
    NOT_TESTABLE(4, #717577);

    private final int value;
    private final color _color;

    ElectrodeState(int newValue, color c) {
        value = newValue;
        _color = c;
    }

    public int getValue() { return value; }

    public int getColor() { return _color; }
}

interface CytonElectrodeEnum {
    public int getIndex();
    public Integer getChanGUI();
    public String getADSChan();
    public String getMeasurementType();
    public boolean isPin_N();
    public float[] getCircleXY();
    public String getLabelName();
    public float[] getLabelXY();
    public float getBorderScalar();
}

public enum CytonElectrodeLocations implements CytonElectrodeEnum
{
    ONE_N(0, 1, "1N", "EEG", 0.10000, 0.38992, "Fp1", 0.50000, 0.15265),
    TWO_N(1, 2, "2N", "EEG", 0.10000, 0.51967, "Fp2", 0.50000, 0.18308),
    THREE_N(2, 3, "3N", "EEG", 0.10000,   0.64941, "C3", 0.50000, 0.11283),
    FOUR_N(3, 4, "4N", "EEG", 0.10000, 0.92547, "C4", 0.50000, 0.17101),
    FIVE_N(4, 5, "5N", "EEG", 0.18140,   0.64941, "P7", 0.38278, 0.19765),
    SIX_N(5, 6, "6N", "EEG", 0.11781,	0.64941, "P8", 0.61722, 0.19765),
    SEVEN_N(6, 7, "7N", "EEG", 0.17313, 0.88820, "O1", 0.37352, 0.15514),
    EIGHT_N(7, 8, "8N", "EEG", 0.12608, 0.88820, "O2", 0.62530, 0.15514),
    NINE_N(8, 9, "9N", "EEG", 0.10000, 0.38992, "F7", 0.50000, 0.15265),
    TEN_N(9, 10, "10N", "EEG", 0.10000, 0.51967, "F8", 0.50000, 0.18308),
    ELEVEN_N(10, 11, "11N", "EEG", 0.10000,   0.64941, "F3", 0.50000, 0.11283),
    TWELVE_N(11, 12, "12N", "EEG", 0.10000, 0.92547, "F4", 0.50000, 0.17101),
    THIRTEEN_N(12, 13, "13N", "EEG", 0.18140,   0.64941, "T7", 0.18278, 0.19765),
    FOURTEEN_N(13, 14, "14N", "EEG", 0.11781,	0.64941, "T8", 0.11722, 0.19765),
    FIFTEEN_N(14, 15, "15N", "EEG", 0.17313, 0.88820, "P3", 0.11352, 0.11514),
    SIXTEEN_N(15, 16, "16N", "EEG", 0.12608, 0.88820, "P4", 0.11530, 0.11514);

    private int index;
    private Integer guiChan;
    private String adsChan;
    private String measurement;
    //Used to draw electrode status circles on the visual map in the correct locations.
    private float xPosScale;
    private float yPosScale;
    //Used to draw labels
    private String labelName;
    private float labelXScale;
    private float labelYScale;

    private static CytonElectrodeLocations[] vals = values();
 
    CytonElectrodeLocations(int index, Integer channel, String adsChan, String type, float xPosScale, float yPosScale, String labelName, float labelXScale, float labelYScale) {
        this.index = index;
        this.guiChan = channel;
        this.adsChan = adsChan;
        this.measurement = type;  
        this.xPosScale = xPosScale;
        this.yPosScale = yPosScale;
        this.labelName = labelName;
        this.labelXScale = labelXScale;
        this.labelYScale = labelYScale;
    }

    @Override
    public int getIndex() {
        return index;
    }

    public static CytonElectrodeLocations getByIndex(int i) {
        return vals[i];
    }

    public static CytonElectrodeLocations getByADSChan(String value) {  
        if (value != null) {  
            for (CytonElectrodeLocations location : values()) {  
                if (location.adsChan.equals(value)) {  
                    return location;  
                }  
            }  
        }
        println("getByADSChan - ERROR | Value == " + value);
        throw new IllegalArgumentException("Invalid electrode location: " + value);
    }

    public static String[] getAllLocationNames() {
        return Arrays.toString(values()).replaceAll("^.|.$", "").split(", ");
    }

    @Override
    public Integer getChanGUI() {
        return guiChan;
    }

    @Override
    public String getADSChan() {
        return adsChan;
    }

    @Override
    public String getMeasurementType() {
        return measurement;
    }

    @Override
    public boolean isPin_N() {
        return adsChan.endsWith("N");
    }

    // 72/2538 = 0.02836
    //Manual adjustment 70%. 0.02836 * .7 = 0.019852
    public static float getDiameterScalar() {
        //return 0.019852; //70%
        return 0.022688; //80%
    }

    @Override
    public float[] getCircleXY() {
        return new float[] { xPosScale, yPosScale };
    }

    @Override
    public String getLabelName() {
        return labelName;
    }

    @Override
    public float[] getLabelXY() {
        return new float[] { labelXScale, labelYScale };
    }

    @Override
    public float getBorderScalar() {
        return 0.05;
    }
}

class CytonElectrodeStatus {

    private CytonElectrodeLocations thisElectrode;

    protected BoardCyton cytonBoard;
    protected Integer channelNumber;
    protected String electrodeLocation;
    protected String measurement;
    protected int dataTableColumnOffset;
    protected double statusValue;
    protected String statusValueAsString;
    protected String anatomicalName;
    protected ElectrodeState state_live;
    protected ElectrodeState state_imp;
    protected NumberFormat railedNF = NumberFormat.getInstance();
    protected DecimalFormat impedanceNF;
    protected DecimalFormat impShortNF;
    //Impedance ranges in kOhms
    protected double impedanceGreenCutoff = 750d;
    protected double impedanceYellowCuttoff = 2500d;
    //Anything greater than impedanceYellowCuttoff is red
    private boolean isCheckingAnotherElectrode = false;
    protected boolean isInImpedanceMode = false;

    protected ControlP5 local_cp5;
    protected Button testing_button;
    protected RectDimensions cellDims;
    protected final int testingButtonPadding = 3;

    protected boolean is_N_Pin = false;

    protected Gif checkingElectrodeGif;
    protected final int gifDiameterBorderOffset = 30; //From the weight of the pixels in the original gif

    CytonElectrodeStatus(ControlP5 _cp5, CytonElectrodeEnum electrodeEnum, BoardCyton _impBoard, Gif statusGif) {
        local_cp5 = _cp5;
        cytonBoard = (BoardCyton)_impBoard;
        impedanceNF = new DecimalFormat("###,###.#");
        impShortNF = new DecimalFormat("###,###");

        thisElectrode = (CytonElectrodeLocations)electrodeEnum;
        channelNumber = thisElectrode.getChanGUI();
        electrodeLocation = thisElectrode.getADSChan();
        measurement = thisElectrode.getMeasurementType();
        anatomicalName = thisElectrode.getLabelName();
        is_N_Pin = thisElectrode.isPin_N();
        railedNF.setMaximumFractionDigits(2);
        dataTableColumnOffset = is_N_Pin ? 1 : 2;
        checkingElectrodeGif = statusGif;

        state_imp = ElectrodeState.GREYED_OUT;
        state_live = ElectrodeState.GREYED_OUT;

        //This will be resized and positioned during session starts when widget is assigned a container
        createCytonElectrodeTestingButton("electrode_"+electrodeLocation, "Test", 0, 0, 20, 10);
    }

    public void draw(int w, int h) {

        float x = w * thisElectrode.getCircleXY()[0];
        float y = h * thisElectrode.getCircleXY()[1];

        ElectrodeState state = getElectrodeState();

        pushStyle();
        fill(state.getColor());
        float d = w * thisElectrode.getDiameterScalar();
        ellipseMode(CENTER);
        ellipse(x, y, d, d);

        if (state != ElectrodeState.NOT_TESTABLE && cytonBoard.isCheckingImpedanceNorP(channelNumber-1, is_N_Pin)) {
            imageMode(CENTER);
            image(checkingElectrodeGif, x - 1, y - 1, d + gifDiameterBorderOffset, d + gifDiameterBorderOffset);
        }
        popStyle();
    }

    public void update(Grid _dataTable, boolean _isImpedanceMode) {
        
        isInImpedanceMode = _isImpedanceMode;
        ElectrodeState state = getElectrodeState();

        if (state == ElectrodeState.NOT_TESTABLE) {
            return;
        }

        int i = channelNumber - 1;

        if (_isImpedanceMode && cytonBoard.isCheckingImpedanceNorP(i, is_N_Pin) && cytonBoard.isStreaming()) {
            
            //update the impedance values
            statusValue = data_elec_imp_ohm[i]/1000; //value in kOhm
            boolean greaterThanZero = statusValue > Double.MIN_NORMAL;
            color railedTextColor = OPENBCI_DARKBLUE;
            if (statusValue > impedanceYellowCuttoff) {
                state_imp = ElectrodeState.RED;
            } else if (statusValue < impedanceYellowCuttoff && statusValue > impedanceGreenCutoff) {
                state_imp = ElectrodeState.YELLOW;
            } else if (greaterThanZero && statusValue < impedanceGreenCutoff) {
                state_imp = ElectrodeState.GREEN;
            }
            //Impedance mode uses buttons carefully positioned in the table to display information
            testing_button.getCaptionLabel().setText(getImpValShortString());
            testing_button.setColorCaptionLabel(state.getColor());

        } else if (!_isImpedanceMode) {

            //update the railed percentage values
            statusValue = is_railed[i].getPercentage();
            boolean greaterThanZero = statusValue > Double.MIN_NORMAL;
            color railedTextColor = OPENBCI_DARKBLUE;
            if (is_railed[i].is_railed) {
                state_live = ElectrodeState.RED;
                railedTextColor = SIGNAL_CHECK_RED;
            } else if (is_railed[i].is_railed_warn) {
                state_live = ElectrodeState.YELLOW;
                railedTextColor = SIGNAL_CHECK_YELLOW;
            } else if (greaterThanZero) {
                state_live = ElectrodeState.BLUE;
            }
            //Railed percentage mode (Live) uses text in the data table
            StringBuilder s = new StringBuilder(railedNF.format(statusValue));
            s.append(" %");
            _dataTable.setString(s.toString(), channelNumber, dataTableColumnOffset);
            _dataTable.setTextColor(railedTextColor, channelNumber, dataTableColumnOffset);

        }
    }

    public String getImpedanceValueAsString(boolean isAnatomicalName) {
        StringBuilder sb = new StringBuilder(isAnatomicalName ? anatomicalName : electrodeLocation);
        sb.append(" - ");
        sb.append(impedanceNF.format(statusValue));
        sb.append(" kOhm");
        return sb.toString();
    }

    public String getImpValShortString() {
        StringBuilder sb = new StringBuilder(impShortNF.format(statusValue));
        sb.append(" k\u2126");
        return sb.toString();
    }

    public Integer getGUIChannelNumber() {
        return channelNumber;
    }

    public final ElectrodeState getElectrodeState() {
        return isInImpedanceMode ? state_imp : state_live;
    }

    public void setElectrodeState(ElectrodeState s) {
        if (isInImpedanceMode) {
            state_imp = s;
        } else {
            state_live = s;
        }
    }

    public boolean getIsNPin() {
        return is_N_Pin;
    }

    public void overrideTestingButtonSwitch(boolean b) {
        if (b) {
            testing_button.setOn();
        } else {
            testing_button.setOff();
        }
    }

    public void updateGreenThreshold(double _d) {
        impedanceGreenCutoff = _d;
    }

    public void updateYellowThreshold(double _d) {
        impedanceYellowCuttoff = _d;
    }

    //Here is the method that creates a "Test" button for every electrode position
    protected void createCytonElectrodeTestingButton(String name, String text, int _x, int _y, int _w, int _h) {
        ElectrodeState state = getElectrodeState();
        if (state == ElectrodeState.NOT_TESTABLE) {
            return; //Some electrode positions cannot be tested
        }
        testing_button = createButton(local_cp5, name, text, _x, _y, _w, _h);
        testing_button.setBorderColor(null);
        testing_button.setColorActive(BUTTON_PRESSED_LIGHT);
        testing_button.setColorForeground(BUTTON_HOVER_LIGHT);
        testing_button.setSwitch(true); //This turns the button into a switch. Switch will be Off by default.
        testing_button.onPress(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
                final int _chan = channelNumber - 1;
                final int curMillis = millis();
                println("CytonElectrodeTestButton: Toggling Impedance on ~~ " + electrodeLocation);
                w_cytonImpedance.toggleImpedanceOnElectrode(!cytonBoard.isCheckingImpedanceNorP(_chan, is_N_Pin), _chan, is_N_Pin, curMillis);
            }
        });
        testing_button.setDescription("Click to toggle impedance check for this ADS pin.");
    }

    public void resizeButton(Grid _dataTable) {
        ElectrodeState state = getElectrodeState();
        if (state == ElectrodeState.NOT_TESTABLE) {
            return; //Some electrode positions cannot be tested
        }
        cellDims = _dataTable.getCellDims(channelNumber, dataTableColumnOffset);
        testing_button.setPosition(cellDims.x, cellDims.y + 1);
        testing_button.setSize(cellDims.w + 1, cellDims.h - 1);
    }

    //Override the electrode state
    public void setElectrodeGreyedOut() {
        ElectrodeState state = getElectrodeState();
        if (state == ElectrodeState.NOT_TESTABLE) {
            return;
        }
        state = ElectrodeState.GREYED_OUT;
    }

    //Override the electrode state
    public void setElectrodeGreenStatus() {
        ElectrodeState state = getElectrodeState();
        if (state == ElectrodeState.NOT_TESTABLE) {
            return;
        }
        state = ElectrodeState.GREEN;
    }

    public void resetTestingButton() {
        testing_button.getCaptionLabel().setText("Test");
        testing_button.setOff();
    }

    public void setLockTestingButton(boolean b) {
        if (testing_button != null) {
            testing_button.setLock(b);
        }
    }

    public Button getTestingButton() {
        return testing_button;
    }

    public void drawLabels(boolean _showAnatomicalName, int container_x, int container_y, int w, int h, PFont _font) {
        pushStyle();
        fill(OPENBCI_DARKBLUE);
        textAlign(CENTER);
        textFont(_font);
        float x = w * thisElectrode.getLabelXY()[0];
        float y = h * thisElectrode.getLabelXY()[1];
        String s = _showAnatomicalName ? thisElectrode.getLabelName() : thisElectrode.getADSChan();
        text(s, container_x + x, container_y + y);
        popStyle();
    }

    public String getThisElectrodeLabel() {
        return thisElectrode.getLabelName();
    }
}

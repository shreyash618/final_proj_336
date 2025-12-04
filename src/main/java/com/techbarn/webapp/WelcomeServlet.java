package com.techbarn.webapp;

public class TV extends ItemBean {
    private String resolution;
    private boolean isHdr;
    private int refreshRate;
    private boolean isSmartTv;
    private int screenSize;
    private String panelType;

    public TV() {
        super();
    }

    // Getters and Setters
    public void setResolution(String resolution) { this.resolution = resolution; }
    public String getResolution() { return resolution; }

    public void setIsHdr(boolean isHdr) { this.isHdr = isHdr; }
    public boolean getIsHdr() { return isHdr; }

    public void setRefreshRate(int refreshRate) { this.refreshRate = refreshRate; }
    public int getRefreshRate() { return refreshRate; }

    public void setIsSmartTv(boolean isSmartTv) { this.isSmartTv = isSmartTv; }
    public boolean getIsSmartTv() { return isSmartTv; }

    public void setScreenSize(int screenSize) { this.screenSize = screenSize; }
    public int getScreenSize() { return screenSize; }

    public void setPanelType(String panelType) { this.panelType = panelType; }
    public String getPanelType() { return panelType; }
}
package com.techbarn.webapp;

public class Headphones extends ItemBean {
    private boolean isWireless;
    private boolean hasMicrophone;
    private boolean hasNoiseCancellation;
    private String cableType;

    public Headphones() {
        super();
    }

    // Getters and Setters
    public void setIsWireless(boolean isWireless) { this.isWireless = isWireless; }
    public boolean getIsWireless() { return isWireless; }

    public void setHasMicrophone(boolean hasMicrophone) { this.hasMicrophone = hasMicrophone; }
    public boolean getHasMicrophone() { return hasMicrophone; }

    public void setHasNoiseCancellation(boolean hasNoiseCancellation) { this.hasNoiseCancellation = hasNoiseCancellation; }
    public boolean getHasNoiseCancellation() { return hasNoiseCancellation; }

    public void setCableType(String cableType) { this.cableType = cableType; }
    public String getCableType() { return cableType; }
}
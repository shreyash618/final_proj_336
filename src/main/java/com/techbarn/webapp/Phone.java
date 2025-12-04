package com.techbarn.webapp;

public class Phone extends ItemBean {
    private String os;
    private int storageGb;
    private int ramGb;
    private float screenSize;
    private int rearCameraMp;
    private int frontCameraMp;
    private boolean isUnlocked;
    private int batteryLife;
    private boolean is5G;

    public Phone() {
        super();
    }

    // Getters and Setters
    public void setOs(String os) { this.os = os; }
    public String getOs() { return os; }

    public void setStorageGb(int storageGb) { this.storageGb = storageGb; }
    public int getStorageGb() { return storageGb; }

    public void setRamGb(int ramGb) { this.ramGb = ramGb; }
    public int getRamGb() { return ramGb; }

    public void setScreenSize(float screenSize) { this.screenSize = screenSize; }
    public float getScreenSize() { return screenSize; }

    public void setRearCameraMp(int rearCameraMp) { this.rearCameraMp = rearCameraMp; }
    public int getRearCameraMp() { return rearCameraMp; }

    public void setFrontCameraMp(int frontCameraMp) { this.frontCameraMp = frontCameraMp; }
    public int getFrontCameraMp() { return frontCameraMp; }

    public void setIsUnlocked(boolean isUnlocked) { this.isUnlocked = isUnlocked; }
    public boolean getIsUnlocked() { return isUnlocked; }

    public void setBatteryLife(int batteryLife) { this.batteryLife = batteryLife; }
    public int getBatteryLife() { return batteryLife; }

    public void setIs5G(boolean is5G) { this.is5G = is5G; }
    public boolean getIs5G() { return is5G; }
}
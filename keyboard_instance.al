<?xml version="1.0" encoding="UTF-8"?>
<Project Version="3" Minor="2" Path="C:/Users/Lenovo/Desktop/FPGA">
    <Project_Created_Time></Project_Created_Time>
    <TD_Version>5.6.71036</TD_Version>
    <UCode>01000100</UCode>
    <Name>keyboard_instance</Name>
    <HardWare>
        <Family>EG4</Family>
        <Device>EG4S20BG256</Device>
        <Speed></Speed>
    </HardWare>
    <Source_Files>
        <Verilog>
            <File Path="keyboard_instance.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="1"/>
                </FileInfo>
            </File>
            <File Path="keyboard_scan.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="2"/>
                </FileInfo>
            </File>
            <File Path="key_filter.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="3"/>
                </FileInfo>
            </File>
            <File Path="onehot2binary.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="4"/>
                </FileInfo>
            </File>
            <File Path="Digitron_TimeDisplay_module.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="5"/>
                </FileInfo>
            </File>
            <File Path="register.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="6"/>
                </FileInfo>
            </File>
            <File Path="led.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="7"/>
                </FileInfo>
            </File>
        </Verilog>
        <ADC_FILE>
            <File Path="keyboard.adc">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="constrain_1"/>
                    <Attr Name="CompileOrder" Val="1"/>
                </FileInfo>
            </File>
        </ADC_FILE>
    </Source_Files>
    <FileSets>
        <FileSet Name="design_1" Type="DesignFiles">
        </FileSet>
        <FileSet Name="constrain_1" Type="ConstrainFiles">
        </FileSet>
    </FileSets>
    <TOP_MODULE>
        <LABEL></LABEL>
        <MODULE>keyboard_instance</MODULE>
        <CREATEINDEX>user</CREATEINDEX>
    </TOP_MODULE>
    <Property>
    </Property>
    <Device_Settings>
    </Device_Settings>
    <Configurations>
    </Configurations>
    <Runs>
        <Run Name="syn_1" Type="Synthesis" ConstraintSet="constrain_1" Description="" Active="true">
            <Strategy Name="Default_Synthesis_Strategy">
            </Strategy>
        </Run>
        <Run Name="phy_1" Type="PhysicalDesign" ConstraintSet="constrain_1" Description="" SynRun="syn_1" Active="true">
            <Strategy Name="Default_PhysicalDesign_Strategy">
                <BitgenProperty::GeneralOption>
                    <unused_io_status>pulldown</unused_io_status>
                </BitgenProperty::GeneralOption>
            </Strategy>
        </Run>
    </Runs>
    <Project_Settings>
        <Step_Last_Change>2021-12-31 15:26:21.809</Step_Last_Change>
        <Current_Step>60</Current_Step>
        <Step_Status>true</Step_Status>
    </Project_Settings>
</Project>

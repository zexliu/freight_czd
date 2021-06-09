package wiki.zex.cloud.example.config.excel;

import com.alibaba.excel.converters.Converter;
import com.alibaba.excel.enums.CellDataTypeEnum;
import com.alibaba.excel.metadata.CellData;
import com.alibaba.excel.metadata.GlobalConfiguration;
import com.alibaba.excel.metadata.property.ExcelContentProperty;
import wiki.zex.cloud.example.enums.GenderType;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class GenderConverter implements Converter<GenderType> {

	@Override
	public Class<GenderType> supportJavaTypeKey() {
		return GenderType.class;
	}

	@Override
	public CellDataTypeEnum supportExcelTypeKey() {
		return CellDataTypeEnum.STRING;
	}

	@Override
	public GenderType convertToJavaData(CellData cellData, ExcelContentProperty contentProperty,
										   GlobalConfiguration globalConfiguration) {

		return GenderType.valueOf(cellData.getStringValue());
	}

	@Override
	public CellData<String> convertToExcelData(GenderType value, ExcelContentProperty contentProperty,
	                                           GlobalConfiguration globalConfiguration) {
		return new CellData<>(value.name()) ;
	}

}

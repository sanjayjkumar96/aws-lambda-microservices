import dayjs from "dayjs";


const addMonthsToGivenDate = (givenDate: string, numberOfMonths: number): string => {
    const date = dayjs(givenDate);
    const result = date.add(numberOfMonths, 'month').format('YYYY-MM-DD');
    return result;
};

export { addMonthsToGivenDate };
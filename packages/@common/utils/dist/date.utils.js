"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.addMonthsToGivenDate = void 0;
const dayjs_1 = __importDefault(require("dayjs"));
const addMonthsToGivenDate = (givenDate, numberOfMonths) => {
    const date = (0, dayjs_1.default)(givenDate);
    const result = date.add(numberOfMonths, 'month').format('YYYY-MM-DD');
    return result;
};
exports.addMonthsToGivenDate = addMonthsToGivenDate;

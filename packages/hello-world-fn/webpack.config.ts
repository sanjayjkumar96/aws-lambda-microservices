import { Configuration } from "webpack";
import { BundleAnalyzerPlugin } from "webpack-bundle-analyzer";
import { resolve } from "path";

export default {
    mode: "production",
    target: "node",
    output: {
        path: resolve(__dirname, "../../dist/hello-world-fn"),
        filename: "index.js",
        libraryTarget: "commonjs2"
    },
    externals: /@aws-sdk\//,
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: "ts-loader",
                exclude: /node_modules/
            }
        ]
    },
    resolve: {
        extensions: [".tsx", ".ts", ".js", ".jsx"]
    },
    plugins: [
        new BundleAnalyzerPlugin({
            analyzerMode: "static",
            openAnalyzer: false
        })
    ],
    optimization: {
        minimize: false,
        nodeEnv: false
    }
} as Configuration;
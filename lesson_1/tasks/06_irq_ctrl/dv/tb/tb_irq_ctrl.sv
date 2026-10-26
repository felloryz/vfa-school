/***************************************************
 * Copyright © 2026 Sergey Chusov.
 * Version 1.0.0.
 * Licensed under CC BY-NC-ND 4.0
 * (Attribution-NonCommercial-NoDerivatives).
 * https://creativecommons.org/licenses/by-nc-nd/4.0
 * SPDX-License-Identifier: CC-BY-NC-ND-4.0
 ***************************************************/

//  ------------------- TODO ---------------------
// | Самостоятельно спроектируйте верификационное |
// | окружение контроллера прерываний.            |
//  ------------------- TODO ---------------------

// Топ-модуль простейшего верификационного
// окружения комбинационного контроллера
// прерываний.
module tb_irq_ctrl;

    //  -------------------- Важно! ---------------------
    // | В качестве примера можно использовать модуль    |
    // | lesson_1/examples/03_fulladder/tb_fulladder.sv  |
    //  -------------------- Важно! ---------------------

    localparam W = 3;

    logic [W-1:0]   reqs_i;
    logic           mode_i;
    logic [W-1:0]   reqs_o;

    irq_ctrl dut (
        .reqs_i    (reqs_i),
        .mode_i    (mode_i),
        .reqs_o    (reqs_o)
    );

    initial begin
        bit [W-1:0] cnt;

        reqs_i = 'x;
        mode_i = 'x;

        #20ns;

        mode_i = 1'b0;
        do begin
            reqs_i = cnt;
            #1ns;
            check(reqs_i, mode_i, reqs_o);
            #19ns;
            cnt++;
        end while (cnt != '0);

        mode_i = 1'b1;
        do begin
            reqs_i = cnt;
            #1ns;
            check(reqs_i, mode_i, reqs_o);
            #19ns;
            cnt++;
        end while (cnt != '0);

        #20ns;
        $finish();
    end

    function automatic void check(logic [W-1:0] reqs_i, logic mode_i, logic [W-1:0] reqs_o);
        logic [W-1:0] reqs_expected;

        reqs_expected = '0;

        if (reqs_i === '0) begin
            reqs_expected = '0;
        end else begin
            if (mode_i) begin
                for (int unsigned i = W-1; i >= 0; i--) begin
                    if (reqs_i[i]) begin
                        reqs_expected[i] = 1'b1;
                        break;
                    end
                end
            end else begin
                for (int unsigned i = 0; i < W; i++) begin
                    if (reqs_i[i]) begin
                        reqs_expected[i] = 1'b1;
                        break;
                    end
                end
            end
        end

        if (reqs_o !== reqs_expected) begin
            $error("Data mismatch! Mode: %1b Input: %3b Expected: %3b Real: %3b", mode_i, reqs_i, reqs_expected, reqs_o);
        end
    endfunction

endmodule

package uk.co.cerihughes.mgm.android.ui

import android.content.Context
import android.graphics.Bitmap
import android.renderscript.Allocation
import android.renderscript.Element
import android.renderscript.RenderScript
import android.renderscript.ScriptIntrinsicBlur
import com.squareup.picasso.Transformation

class BlurTransformation(private val context: Context): Transformation {
    override fun key(): String {
        return "BlurTransformation"
    }

    override fun transform(source: Bitmap): Bitmap {
        val width = Math.round(source.width * 0.4).toInt()
        val height = Math.round(source.height * 0.4).toInt()

        val inputBitmap = Bitmap.createScaledBitmap(source, width, height, false)
        val outputBitmap = Bitmap.createBitmap(inputBitmap)

        val rs = RenderScript.create(context)
        val theIntrinsic = ScriptIntrinsicBlur.create(rs, Element.U8_4(rs))
        val tmpIn = Allocation.createFromBitmap(rs, inputBitmap)
        val tmpOut = Allocation.createFromBitmap(rs, outputBitmap)
        theIntrinsic.setRadius(7.5f)
        theIntrinsic.setInput(tmpIn)
        theIntrinsic.forEach(tmpOut)
        tmpOut.copyTo(outputBitmap)

        source.recycle()

        return outputBitmap
    }
}
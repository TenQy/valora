import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Un widget de texto que se trunca a [maxLines] líneas y muestra un botón 
/// de "Ver más" / "Ver menos" si el texto excede el límite.
class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
  });

  final String text;
  final int maxLines;
  final TextStyle? style;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    // Hacemos scroll para asegurar que el texto sea visible después de animarse
    if (_isExpanded) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5, // Trata de centrarlo en la pantalla
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Usamos TextPainter para medir si el texto excede las líneas máximas
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  maxLines: _isExpanded ? null : widget.maxLines,
                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: widget.style,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _toggleExpand,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Ver menos' : 'Ver más',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: AppColors.green,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text(widget.text, style: widget.style);
        }
      },
    );
  }
}
